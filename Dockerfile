### A Multi-Stage-Dockerfile to create a container which is provisioned with
### all the tooling necessary to provision the infrastructure.

### Base
# Setup build arguments with default versions
ARG KOPS_VERSION=${KOPS_VERSION:-v1.25.0}
ARG KAFKA_VERSION=${KAFKA_VERSION:-2.2.2}
ARG SCALA_VERSION=${SCALA_VERSION:-2.12}
ARG FLY=${FLY:-7.9.0}
ARG HELM_VERSION=${HELM_VERSION:-"3.10.3"}
ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-"0.67.4"}
ARG TERRAFORM_VERSION=${TERRAFORM_VERSION:-"1.10.0"}

ARG TF_KAFKA_PROVIDER_NAME=terraform-provider-kafka

# build base image
ARG ARCH=${ARCH:-${ARCH}}
ARG UNAME=${UNAME:-${UNAME}}
ARG IMAGE=${IMAGE:-amazon/aws-cli}
ARG TAG=${TAG:-latest}
FROM $IMAGE:$TAG as base
ENV GLIBC_VER=2.31-r0 
ARG ARCH

USER root

### install missing tools
RUN yum install -y -q \
  apparmor-profiles \
  bash \
  bash-completion \
  bind-utils \
  ca-certificates \
  coreutils \
  curl \
  dialog \
  dos2unix \
  findutils \
  fzf \
  git \
  grep \
  groff \
  htop \
  joe \
  jq \
  less \
  mailx \
  make \
  mutt \
  mysql-client \
  nano \
  ncdu \
  ncurses \
  neovim \
  nmap \
  openjdk8-jre \
  openldap-clients \
  openssh-client \
  openssl \
  outils-sha256 \
  perl \
  postgresql-client \
  py3-pip \
  python3 \
  rsync \
  sed \
  shadow \
  strace \
  sudo \
  tar \
  tzdata \
  unzip \
  util-linux \
  util-linux-user \
  vim \
  wget \
  zsh 

### install pip packages from requirements.txt and awscli v2
### disabled: ansible-vault
COPY requirements.txt /tmp
RUN pip3 install --upgrade --force-reinstall pip \
  && python3 -m ensurepip --upgrade \
  && pip3 install --ignore-installed -r /tmp/requirements.txt

WORKDIR /workspace
CMD ["bash"]

# terraform
FROM base as terraform
ARG ARCH
RUN git clone https://github.com/tfutils/tfenv.git /usr/local/tfenv
RUN find /usr/local/tfenv -type f -print0 | xargs -0 sed -i "s/amd64/${ARCH}/g"

# terragrunt
FROM base as terragrunt
ARG ARCH
RUN git clone https://github.com/cunymatthieu/tgenv.git /usr/local/tgenv
RUN find /usr/local/tgenv -type f -print0 | xargs -0 sed -i "s/amd64/${ARCH}/g"

#terraform-providers: kafka, fm, mongodbatlas, ldap
#terraform-providers: kafka

#FROM base AS terraform-provider-kafka
#ARG ARCH
#WORKDIR /
#COPY gh-dl-release.sh .
#ARG TF_KAFKA_PROVIDER_NAME
#RUN curl --silent --location --output ${TF_KAFKA_PROVIDER_NAME}_linux_${ARCH}.zip -s "$(curl -s https://api.github.com/repos/Mongey/terraform-provider-kafka/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux_$ARCH")" \
# && unzip ${TF_KAFKA_PROVIDER_NAME}_linux_${ARCH}.zip > /dev/null \
# && mv ${TF_KAFKA_PROVIDER_NAME}_v* ${TF_KAFKA_PROVIDER_NAME}

### kubectl
FROM base AS kubectl
ARG ARCH
WORKDIR /tmp
RUN curl --silent --location --output kubectl \ 
  https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${ARCH}/kubectl \
  && chmod +x kubectl

### helm
#FROM base AS helm
#ARG ARCH
#RUN git clone https://github.com/yuya-takeyama/helmenv.git /usr/local/helmenv

#### kops
#FROM base AS kops
#ARG ARCH
#ARG KOPS_VERSION
#WORKDIR /tmp
#RUN curl --silent --location --output kops \
#  https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-${ARCH} \
#  && curl --silent --location --output kops-sha1 \
#  https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-${ARCH}-sha1 \
#  && echo Download checksum: $(sha1sum kops) \
#  && sha1sum kops | grep "$(cat kops-sha1)" \
#  && chmod +x kops

### kafka
#FROM base AS kafka
#ARG ARCH
#ARG KAFKA_VERSION
#ARG SCALA_VERSION
#
#LABEL name="kafka" version=${KAFKA_VERSION}
#
#RUN apk add --no-cache openjdk8-jre bash docker coreutils su-exec
#RUN apk add --no-cache -t .build-deps curl ca-certificates jq \
#  && mkdir -p /opt && curl -sSL "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
#  | tar -xzf - -C /opt \
#  && mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
#  && adduser -DH -s /sbin/nologin kafka \
#  && chown -R kafka: /opt/kafka \
#  && rm -rf /tmp/* \
#  && apk del --purge .build-deps

### build final image
FROM base as final
ARG ARCH
ARG UNAME
#RUN adduser -DH -s /sbin/nologin kafka --uid 5001

### set go path
ENV PATH=$PATH:/usr/local/go/bin:~/.local/bin:/usr/local/bin

### set timezone
ENV TZ Europe/Berlin
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && echo "Europe/Brussels" >  /etc/timezone

### set locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UFT-8

### set default editor
ENV EDITOR nvim

### helm
RUN curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 /tmp/get_helm.sh \
    && /tmp/get_helm.sh \
    && rm /tmp/get_helm.sh

### kubectx
RUN wget -O /usr/local/bin/kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx \
  && wget -O /usr/local/bin/kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens \
  && chmod +x /usr/local/bin/kube*

### final steps
RUN curl --silent -Lo /usr/local/bin/kind "https://kind.sigs.k8s.io/dl/v0.9.0/kind-$(uname)-${ARCH}" && chmod +x /usr/local/bin/kind
#RUN curl -Lo /usr/local/bin/devspace "https://github.com/devspace-cloud/devspace/releases/download/v5.0.3/devspace-linux-${ARCH}" && chmod +x /usr/local/bin/devspace

#COPY --from=helm	/usr/local/helmenv/bin		/usr/local/helmenv/bin
#COPY --from=helm 	/usr/local/helmenv/libexec	/usr/local/helmenv/libexec
#ARG HELM_VERSION
#RUN ln -s /usr/local/helmenv/bin/helmenv /usr/local/bin/helmenv \
#  && ln -s /usr/local/helmenv/bin/helm /usr/local/bin/helm

### install helmfile
RUN curl --silent --location --output /usr/local/bin/helmfile $( curl -s https://api.github.com/repos/roboll/helmfile/releases | jq -r ' .[].assets[].browser_download_url' | grep linux_${ARCH} | head -1) \
  && chmod +x /usr/local/bin/helmfile

### install terraform-docs
RUN curl --silent --location --output /usr/local/bin/terraform-docs $( curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases | jq -r ' .[].assets[].browser_download_url' | grep linux-${ARCH} | head -1) \
  && chmod +x /usr/local/bin/terraform-docs

### tflint
RUN curl --silent --location --output tflint.zip "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_${ARCH}.zip")" && unzip tflint.zip && rm tflint.zip \
  && mv tflint /usr/local/bin \
  && chmod +x /usr/local/bin/tflint

### fly
ARG FLY
RUN curl --silent --location --output fly.tgz -s "$(curl -s https://api.github.com/repos/concourse/concourse/releases | jq -r ' . [] | select(.tag_name|test("v'${FLY}'")) | .assets[] | .browser_download_url' | grep "fly-${FLY}-linux-${ARCH}.tgz$")" \
 && tar -xvzf fly.tgz -C . \
 && chmod +x fly \
 && mv fly /usr/local/bin \
 && rm fly.tgz || exit 0

### jid
RUN curl --silent --location --output jid.zip -s "$(curl -s https://api.github.com/repos/simeji/jid/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux_${ARCH}" )" \
  && unzip jid.zip \
  && chmod +x jid \
  && mv jid /usr/local/bin \
  && rm jid.zip

### aws-iam-authentificator
RUN curl --silent --location --output /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/${ARCH}/aws-iam-authenticator \
  && chmod +x /usr/local/bin/aws-iam-authenticator

### install yq
RUN curl --silent --location --output /usr/local/bin/yq "$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux_${ARCH}$")" \
  && chmod +x /usr/local/bin/yq

### eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${ARCH}.tar.gz" | tar xz -C /tmp \
  && sudo chmod +x /tmp/eksctl \
  && sudo mv /tmp/eksctl /usr/local/bin

### hub
RUN curl --silent --location --output hub.tgz -s "$(curl -s https://api.github.com/repos/mislav/hub/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux-${ARCH}" )" \
  && tar -xvzf hub.tgz $(tar -tzf hub.tgz | grep bin/hub) \
  && mv hub-*/bin/hub /usr/local/bin \
  && rm -rf hub-linux-${ARCH}* hub.tgz

### aws-vault
RUN curl --silent --location --output /usr/local/bin/aws-vault -s "$(curl -s https://api.github.com/repos/99designs/aws-vault/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux-${ARCH}" )" \
  && chmod +x /usr/local/bin/aws-vault

### direnv
RUN curl --silent --location --output /usr/local/bin/direnv "$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest  | jq -r ' .assets[] | .browser_download_url' | grep "linux-${ARCH}")" \
  && chmod +x /usr/local/bin/direnv

### tfsec
RUN curl --silent --location --output /usr/local/bin/tfsec "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest  | jq -r ' .assets[] | .browser_download_url' | grep "tfsec-linux-${ARCH}$")" \
  && chmod +x /usr/local/bin/tfsec

### tflint
RUN curl --silent --location --output tflint.zip -s "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux_${ARCH}" )" \
  && unzip tflint.zip \
  && chmod +x tflint \
  && mv tflint /usr/local/bin \
  && rm tflint.zip

### aws cdk
### configure yum repo for nodejs
### 17 version is latest possible because of ldd (2.26) version for current image amazon/aws-cli
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
  && export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] \
  && . "$NVM_DIR/nvm.sh" \
  && nvm install 17 \
  && nvm use 17 \
  && npm install -g aws-cdk

### miller
RUN curl --silent --location --output miller.tar.gz -s "$( curl -s https://api.github.com/repos/johnkerl/miller/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux-${ARCH}.tar.gz" )" \
  && tar -xvzf miller.tar.gz "miller*/mlr" -C . \
  && mv miller*/mlr /usr/local/bin \
  && rm -rf miller*

### session-manager
RUN if ( test "$ARCH" == "amd64" ); then SM_ARCH=64bit; else SM_ARCH=arm64; fi && sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_${SM_ARCH}/session-manager-plugin.rpm

#terraform graph beautifier
RUN curl --silent --location --output tf-graph-beauty.tar.gz $(curl -s https://api.github.com/repos/pcasteran/terraform-graph-beautifier/releases/latest | jq -r ' .assets[] | .browser_download_url' | grep "linux_${ARCH}.tar.gz$") \
  && tar -xvzf tf-graph-beauty.tar.gz terraform-graph-beautifier \
  && mv terraform-graph-beautifier /usr/local/bin/

COPY --from=terraform	/usr/local/tfenv/bin		/usr/local/tfenv/bin
COPY --from=terraform	/usr/local/tfenv/lib		/usr/local/tfenv/lib
COPY --from=terraform	/usr/local/tfenv/libexec	/usr/local/tfenv/libexec
COPY --from=terraform	/usr/local/tfenv/share		/usr/local/tfenv/share

#ARG TF_KAFKA_PROVIDER_NAME
#COPY --from=terraform-provider-kafka /${TF_KAFKA_PROVIDER_NAME} /usr/local/terraform-plugins/terraform-provider-kafka

RUN ln -s /usr/local/tfenv/bin/tfenv /usr/local/bin/tfenv \
  && /usr/local/bin/tfenv install ${TERRAFORM_VERSION} \
  && export TERRAFORM_VERSION=$(tfenv list-remote | head -1) \
  && ln -s /usr/local/tfenv/bin/terraform /usr/local/bin/terraform

COPY --from=terragrunt	/usr/local/tgenv		/usr/local/tgenv 
RUN ln -s /usr/local/tgenv/bin/terragrunt /usr/local/bin/terragrunt \
  && ln -s /usr/local/tgenv/bin/tgenv /usr/local/bin/tgenv \
  && export TERRAGRUNT_VERSION=$(tgenv list-remote | head -1) \
  && /usr/local/bin/tgenv install ${TERRAGRUNT_VERSION}

COPY --from=kubectl  	/tmp/kubectl			/usr/local/bin/kubectl
#COPY --from=kops	/tmp/kops			/usr/local/bin/kops
#COPY --from=kafka       /opt/kafka			/opt/kafka
#RUN chown -R kafka: /opt/kafka

#COPY --from=sessionmanagerplugin /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/

### copy all prebuilded tools from other docker images
### zsh installation
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /oh-my-zsh 
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-/oh-my-zsh/custom}/plugins/zsh-completions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/bhilburn/powerlevel9k.git /powerlevel9k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /powerlevel10k
RUN curl --output /usr/local/bin/kube-ps1.sh  https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh && chmod +x /usr/local/bin/kube-ps1.sh
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "/zsh-syntax-highlighting" --depth 1

COPY settings-and-configs.sh /usr/local/bin/settings-and-configs.sh
RUN /usr/local/bin/settings-and-configs.sh

COPY git-* /usr/local/bin/

#ARG HELM_VERSION
#RUN if [ "$HELM_VERSION" != "" ]; then for version in $HELM_VERSION; do helmenv install "$version"; helmenv local "$version"; done; fi

#ARG TERRAFORM_VERSION
#RUN if [ "$TERRAFORM_VERSION" != "" ]; then for version in $TERRAFORM_VERSION; do tfenv install "$version"; tfenv use "$version"; done; fi

#ARG TERRAGRUNT_VERSION
#RUN if [ "$TERRAGRUNT_VERSION" != "" ]; then for version in $TERRAGRUNT_VERSION; do export PATH=$PATH:/usr/local/bin:/usr/local/tgenv/bin; tgenv install "$version"; tgenv use "$version"; done; fi

RUN curl -sfL https://direnv.net/install.sh | bash
