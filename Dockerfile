# Build arguments with default versions
# update docker image 2025-08-01
ARG KOPS_VERSION=${KOPS_VERSION:-v1.25.0}
ARG KAFKA_VERSION=${KAFKA_VERSION:-3.8.0}
ARG SCALA_VERSION=${SCALA_VERSION:-2.13}
ARG HELM_VERSION=${HELM_VERSION:-"latest"}
ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-"latest"}
ARG TERRAFORM_VERSION=${TERRAFORM_VERSION:-"latest"}

ARG ARCH=${ARCH:-${ARCH}}
ARG UNAME=${UNAME:-${UNAME}}
ARG IMAGE=${IMAGE:-amazonlinux}
ARG TAG=${TAG:-2023}

# Base image with system packages
FROM $IMAGE:$TAG as base
ENV GLIBC_VER=2.31-r0 
ARG ARCH

USER root

# Install all system packages in one layer and clean up
RUN yum install -y -q \
    aws-cli bash bash-completion bind-utils ca-certificates dialog dos2unix \
    findutils gettext git glibc-langpack-en glibc-locale-source grep groff \
    htop jq less mailx make mariadb105 mutt nano ncurses nmap openldap-clients \
    openssh-clients openssl perl postgresql16 python3.11-pip python3.11 rsync \
    sed shadow strace sudo tar tzdata unzip util-linux util-linux-user vim \
    wget zsh && \
    yum clean all && \
    rm -rf /var/cache/yum/* && \
    localedef --no-archive -i en_US -f UTF-8 en_US.UTF-8

# Python packages and AWS CLI v2 in one layer
COPY requirements.txt /tmp/
RUN pip3.11 install --upgrade --force-reinstall pip && \
    python3.11 -m ensurepip --upgrade && \
    pip3.11 install --ignore-installed -r /tmp/requirements.txt && \
    rm -rf /tmp/* /root/.cache/pip

WORKDIR /workspace

# Download stage - all external downloads in one stage
FROM base as downloader
ARG ARCH
ARG KAFKA_VERSION
ARG SCALA_VERSION

LABEL name="kafka" version=${KAFKA_VERSION}

WORKDIR /tmp

# Set architecture variables for different tools
RUN if [ "$ARCH" = "amd64" ]; then \
        export D_ARCH=x86_64 SM_ARCH=64bit SM_ARCH2=x86_64; \
    else \
        export D_ARCH=aarch64 SM_ARCH=arm64 SM_ARCH2=arm64; \
    fi && \
    echo "D_ARCH=${D_ARCH}" > /tmp/arch_vars && \
    echo "SM_ARCH=${SM_ARCH}" >> /tmp/arch_vars && \
    echo "SM_ARCH2=${SM_ARCH2}" >> /tmp/arch_vars

# Docker Compose
RUN . /tmp/arch_vars && \
    curl --silent --location "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod 755 /usr/local/bin/docker-compose

# Docker binary
RUN . /tmp/arch_vars && \
    curl --silent --location "https://download.docker.com/linux/static/stable/${D_ARCH}/docker-27.3.1.tgz" | tar xz && \
    mv docker/docker /usr/local/bin/ && \
    rm -rf docker/

# OpenTofu
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh && \
    chmod +x install-opentofu.sh && \
    ./install-opentofu.sh --install-method rpm && \
    rm install-opentofu.sh

# Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# kubectl
RUN . /tmp/arch_vars && \
    curl --silent --location "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${ARCH}/kubectl" -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# kubectx & kubens
RUN curl --silent --location https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -o /usr/local/bin/kubectx && \
    curl --silent --location https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -o /usr/local/bin/kubens && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# kind
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases | jq -r '.[].assets[].browser_download_url' | grep linux-${ARCH} | head -1)" -o /usr/local/bin/kind && \
    chmod +x /usr/local/bin/kind

# helmfile
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/roboll/helmfile/releases | jq -r '.[].assets[].browser_download_url' | grep linux_${ARCH} | head -1)" -o /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/helmfile

# terraform-docs
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases | jq -r '.[].assets[].browser_download_url' | grep linux-${ARCH} | head -1)" | tar xz && \
    mv terraform-docs /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform-docs

# tflint
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_${ARCH}.zip")" -o tflint.zip && \
    unzip tflint.zip && \
    mv tflint /usr/local/bin/ && \
    chmod +x /usr/local/bin/tflint && \
    rm tflint.zip

# jid
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/simeji/jid/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux_${ARCH}")" -o jid.zip && \
    unzip jid.zip && \
    mv jid /usr/local/bin/ && \
    chmod +x /usr/local/bin/jid && \
    rm jid.zip

# aws-iam-authenticator
RUN . /tmp/arch_vars && \
    curl --silent --location "https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/${ARCH}/aws-iam-authenticator" -o /usr/local/bin/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator

# yq
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux_${ARCH}$")" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# eksctl
RUN . /tmp/arch_vars && \
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${ARCH}.tar.gz" | tar xz && \
    mv eksctl /usr/local/bin/ && \
    chmod +x /usr/local/bin/eksctl

# hub
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/mislav/hub/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux-${ARCH}")" -o hub.tgz && \
    tar -xzf hub.tgz --strip-components=2 --wildcards "*/bin/hub" && \
    mv hub /usr/local/bin/ && \
    chmod +x /usr/local/bin/hub && \
    rm hub.tgz

# aws-vault
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/99designs/aws-vault/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux-${ARCH}")" -o /usr/local/bin/aws-vault && \
    chmod +x /usr/local/bin/aws-vault

# nvim
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "nvim-linux-${SM_ARCH2}.tar.gz$")" | tar -xz --strip-components=2 --wildcards "*/bin/nvim" && \
    mv nvim /usr/local/bin/ && \
    chmod +x /usr/local/bin/nvim

# direnv
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux-${ARCH}")" -o /usr/local/bin/direnv && \
    chmod +x /usr/local/bin/direnv

# tfsec
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "tfsec-linux-${ARCH}$")" -o /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec

# Amazon Q
RUN . /tmp/arch_vars && \
    curl --silent --location "https://desktop-release.q.us-east-1.amazonaws.com/latest/q-${D_ARCH}-linux.zip" -o q.zip && \
    unzip q.zip && \
    mv q/bin/* /usr/local/bin/ && \
    rm -rf q/ q.zip

# just
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/casey/just/releases | jq -r '.[].assets[].browser_download_url' | grep ${D_ARCH}-unknown-linux | head -1)" | tar xz && \
    mv just /usr/local/bin/

# zellij
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "zellij-${D_ARCH}-unknown-linux-musl.tar.gz$")" | tar -xz -C /usr/local/bin

# miller
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/johnkerl/miller/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux-${ARCH}.tar.gz")" -o miller.tar.gz && \
    tar -xzf miller.tar.gz --strip-components=1 --wildcards "*/mlr" && \
    mv mlr /usr/local/bin/ && \
    rm miller.tar.gz

# granted/assume
RUN . /tmp/arch_vars && \
    curl --silent --location "https://releases.commonfate.io/granted/v0.31.0/granted_0.31.0_linux_${SM_ARCH2}.tar.gz" -o granted.tar.gz && \
    tar -xzf granted.tar.gz -C /usr/local/bin/ && \
    rm granted.tar.gz

# terraform-graph-beautifier
RUN . /tmp/arch_vars && \
    curl --silent --location "$(curl -s https://api.github.com/repos/pcasteran/terraform-graph-beautifier/releases/latest | jq -r '.assets[] | .browser_download_url' | grep "linux_${ARCH}.tar.gz$")" -o tf-graph-beauty.tar.gz && \
    tar -xzf tf-graph-beauty.tar.gz terraform-graph-beautifier && \
    mv terraform-graph-beautifier /usr/local/bin/ && \
    rm tf-graph-beauty.tar.gz

# Kafka
RUN mkdir -p /opt && \
    curl --silent --location "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" | tar -xz -C /opt && \
    mv "/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" /opt/kafka

# Clean up
RUN rm -rf /tmp/*

# Environment setup stage
FROM base as env-setup

# Install Node.js and AWS CDK in one layer
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    nvm use 22 && \
    npm install -g aws-cdk && \
    rm -rf /root/.npm /tmp/*

# Install session manager plugin
ARG ARCH
RUN if [ "$ARCH" = "amd64" ]; then SM_ARCH=64bit; else SM_ARCH=arm64; fi && \
    yum install -y "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_${SM_ARCH}/session-manager-plugin.rpm" && \
    yum clean all && \
    rm -rf /var/cache/yum/*

# ZSH and shell setup in one layer
RUN git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /oh-my-zsh && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions /oh-my-zsh/custom/plugins/zsh-completions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/bhilburn/powerlevel9k.git /powerlevel9k && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /powerlevel10k && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /zsh-syntax-highlighting && \
    curl -o /usr/local/bin/kube-ps1.sh https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh && \
    chmod +x /usr/local/bin/kube-ps1.sh && \
    rm -rf /tmp/*

# Terraform and Terragrunt setup
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git /usr/local/tfenv && \
    git clone --depth=1 https://github.com/cunymatthieu/tgenv.git /usr/local/tgenv && \
    find /usr/local/tfenv -type f -exec sed -i "s/amd64/${ARCH}/g" {} \; && \
    find /usr/local/tgenv -type f -exec sed -i "s/amd64/${ARCH}/g" {} \; && \
    ln -s /usr/local/tfenv/bin/tfenv /usr/local/bin/tfenv && \
    ln -s /usr/local/tfenv/bin/terraform /usr/local/bin/terraform && \
    ln -s /usr/local/tgenv/bin/terragrunt /usr/local/bin/terragrunt && \
    ln -s /usr/local/tgenv/bin/tgenv /usr/local/bin/tgenv

# Final stage
FROM env-setup as final
ARG ARCH
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION

# Copy all binaries from downloader stage
COPY --from=downloader /usr/local/bin/* /usr/local/bin/
COPY --from=downloader /opt/kafka /opt/kafka

# Set environment variables
ENV PATH=$PATH:/usr/local/go/bin:~/.local/bin:/usr/local/bin
ENV TZ=Europe/Berlin
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV EDITOR=nvim

# Set timezone and create kafka user
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    echo "Europe/Berlin" > /etc/timezone && \
    adduser -s /sbin/nologin kafka && \
    chown -R kafka: /opt/kafka

# Copy configuration scripts and git tools
COPY settings-and-configs.sh /usr/local/bin/settings-and-configs.sh
COPY git-* /usr/local/bin/
RUN /usr/local/bin/settings-and-configs.sh

# Install specific terraform and terragrunt versions if specified
RUN if [ "$TERRAFORM_VERSION" != "latest" ] && [ -n "$TERRAFORM_VERSION" ]; then \
        for version in $TERRAFORM_VERSION; do \
            tfenv install "$version" && tfenv use "$version"; \
        done; \
    else \
        tfenv install latest && tfenv use latest; \
    fi

RUN if [ "$TERRAGRUNT_VERSION" != "latest" ] && [ -n "$TERRAGRUNT_VERSION" ]; then \
        for version in $TERRAGRUNT_VERSION; do \
            tgenv install "$version" && tgenv use "$version"; \
        done; \
    else \
        tgenv install latest && tgenv use latest; \
    fi

# Final direnv installation
RUN curl -sfL https://direnv.net/install.sh | bash && \
    rm -rf /tmp/* /var/cache/yum/* /root/.cache

WORKDIR /workspace
CMD ["bash"]
