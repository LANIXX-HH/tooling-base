# Tooling base

What's it for?

This is a toolkit from our team which may help you. Firstly, it is a working example (we do not give a 100% guarantee of course and any feedback is welcome!), an OS-independent installation that can be used immediately and secondly it is a collection of utilities and an example of how to install them (see Dockerfile recipe).

## What can I find here?

based on alpine:edge

base packages:

* all k8s tools: kubectl, kubectx, kubens
* helm with helmenv
* helmfile
* aws sso wrapper: aws-sso.py and additional help wrapper for shell session
* terraform with tfenv
* terragrunt with tgenv
* aws cli v2
* docker
* docker-compose
* git scripts: git-pair, git-solo, git-authors, git-time, git-pp, git-changelog
* zsh, zsh-completions, zsh-suggestions, powerline, oh-my-zsh

##Useful Commands and Configs

###Commands

* git pair – pair with other people on git repositorys. this command will create default commit message with co-authored-by refence. you must use git commit without additional parameters to autofill co-authored-by reference
* git solo – reset git pair
* aws-sso.sh – This wrapper helps you to use existing profiles, export aws credentials for the current tty session, import credentials and write current temporary credentials variables to ~/.local/aws-sso-envs. If you don't have an active sso session or a configured sso profile, this wrapper will help you to login or create a new profile. example: 
AWS_EXPORT_VALUES="PRF ENV CRD" AWS_PROFILE=stage-dev AWS_ASSUME="yes" AWS_ASSUME_ROLE="continuous" aws-sso.sh && source ~/.local/aws-sso-envs
* aws-assume.sh – This wrapper helps you to assume specific iam role. example: 
$(aws-assume.sh ”arn:aws:iam::808833771028:role/continuous” ”stage-dev” ”3600”) or $(aws-assume.sh)
* fly – You already have the right version for our Concourse installation
* kubectx (short alias kx) – use specific kubernetes cluster context aka kubectl config use-context kubernetes.dev.cloudhh.de 
* kubens (short alias kn) – select specific kubernetes namespace for current selected kubernetes cluster
* jid – You can drill down JSON interactively by using filtering queries like jq. (simeji/jid )

## How To use it (docker-compose example)

### Prerequsites

### How To use on Linux or MacOS

```
cd /path/to/tooling/image
UID=$(id -u) docker-compose build
```

for Linux:

```shell
docker-compose -f docker-compose.yml -f volumes.yml run --rm tooling
```

for MacOS:

```shell
docker-compose -f docker-compose.yml -f volumes-mac.yml run --rm tooling
```

### How To use on Windows

#### Pre Steps:

`git config --global core.autocrlf input` - settings to clone ae_infrastructure repository with LF newline style (UNIX). 
You can change all *.py and *.sh files in tooling/ directory manually and save files with LF newline format

create your own volumes-windows.yml version with additional shares

#### PowerShell Steps:

```
cd C:\Path\To\tooling\image
$env:USER=$env:USERNAME 
docker-compose build
$env:AWS_PROFILE="<your_aws_sso_profile>"
docker-compose -f docker-compose.yml -f my-own-volumes-windows.yml run --rm tooling bash
```

### docker-compose.yml

```yaml
version: "3"
services:
  tooling:
    privileged: true
    entrypoint: "/entrypoint.sh"
    network_mode: "host"
    container_name: "tooling"
    hostname: "tooling"
    build:
      context: .
      args:
        IMAGE: ghcr.io/lanixx-hh/tooling-base:latest
        TAG: latest
        USER: ${USER:-user}
        UID: ${UID:-1000}
        TERRAFORM_VERSION: '0.11.14 0.12.29'
        TERRAGRUNT_VERSION: '0.25.5 0.25.3' 
        HELM_VERSION: '2.14.3 3.1.1'
    environment:
      SHELL: /bin/zsh
      KUBECONFIG: /home/${USER}/.kube/config
      SSH_PRIVATE_KEY_FILE: /home/${USER}/.ssh/id_rsa
      SSO_PROFILE: ${SSO_PROFILE:-}
```

### volumes-windows.yml

```yaml
version: "3"
services:
  tooling:
    volumes:
      - "C:\Users\${USERNAME}\Path:/container/path"
```

### volumes-mac.yml

```yaml
version: "3"
services:
  tooling:
    volumes:
      - /Users:/Users
      - /Volumes:/Volumes
      - ${HOME}:${HOME}
      - ${HOME}:/home/${USER}
```

### volumes.yml

```yaml
version: "3"
services:
  tooling:
    volumes:
      - /host/path:/container/path
```

### example yaml for runfromyaml wrapper

```yaml
---
cmd:
  - type: "shell"
    name: "lsh"
    desc: "create tooling directory"
    values:
      - mkdir -p /tmp/tooling
  - type: "conf"
    confdest: /tmp/tooling/aws-assume.sh
    confperm: 0755
    confdata: |
      #!/bin/bash

      SSO_ACCOUNT=$(aws sts get-caller-identity --output json --profile "$AWS_PROFILE" | jq -r '.Account')
      export ROLE=${1:-arn:aws:iam::$SSO_ACCOUNT:role/continuous}
      export NAME=${2:-$SSO_PROFILE}
      export DURATION=${3:-3600}

      aws sts assume-role --output json --role-arn "$ROLE" --role-session-name "$NAME" --duration-seconds "$DURATION" --profile "$AWS_PROFILE" | jq -r ' "export AWS_ACCESS_KEY_ID=" + .Credentials.AccessKeyId + "\n" + "export AWS_SECRET_ACCESS_KEY=" + .Credentials.SecretAccessKey + "\n" + "export AWS_SECURITY_TOKEN=" + .Credentials.SessionToken + "\n" + "export AWS_SESSION_TOKEN=" + .Credentials.SessionToken'
  - type: "conf"
    confdest: /tmp/tooling/entrypoint.sh
    confperm: 0755
    confdata: |
      #!/bin/bash

      export KUBECONFIG=$KUBECONFIG
      ### set docker sock rights
      sudo chmod 0777 /var/run/docker.sock >/dev/null 2>&1
      sudo chmod 0777 /tmp/boot.log >/dev/null 2>&1
      sudo chmod 666 /dev/null

      ### init env
      (
        echo "### START"
        date
      ) >>/tmp/boot.log

      echo "### END" >>/tmp/boot.log 2>&1

      ### if run interactive shell
      if [ -t 0 ]; then

        git config --global pull.rebase true
        git config --global rebase.autoStash true
        git config --global push.default current

        echo "start ssh-agent ..."
        (
          eval "$(ssh-agent -s)"
          ssh-add "$SSH_PRIVATE_KEY_FILE"
        ) >>/tmp/boot.log 2>&1
        echo "export kubeconfig $KUBECONFIG"
        export KUBECONFIG=$KUBECONFIG
      fi

      ### run command
      if [ "x$*" = "x" ]; then
        exec "$SHELL"
      else
        exec "$@"
      fi

  - type: "conf"
    confdata: |
      ### A Multi-Stage-Dockerfile to create a container which is provisioned with
      ### all the tooling necessary to provision the infrastructure

      ### build final image
      ARG USER=${USER:-user}
      ARG UID=${UID:-1000}
      ARG IMAGE=${IMAGE:-final}
      ARG TAG=${TAG:-latest}
      #ARG HELM_VERSION=${HELM_VERSION:-3.1.1}
      #ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-0.25.3}
      #ARG TERRAFORM_VERSION=${TERRAFORM_VERSION:-'[0.12.29]'}

      FROM $IMAGE:$TAG

      ARG USER
      ARG UID
      #ARG TERRAFORM_VERSION
      #ARG TERRAGRUNT_VERSION
      #ARG HELM_VERSION

      USER root

      ### create runner user and group
      RUN addgroup ${USER:-user}
      RUN adduser \
          --disabled-password \
          --gecos "" \
          --home "/home/${USER}" \
          --ingroup "${USER}" \
          --uid "${UID}" \
          ${USER}

      ### add sudo
      RUN echo "${USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user


      ### make user 'user' as default and set home dir as workdir
      #RUN addgroup docker && addgroup ${USER:-user} docker
      WORKDIR /home/${USER:-user}

      RUN rm /bin/sh && ln -s /bin/bash /bin/sh && rm /bin/ash && ln -s /bin/bash /bin/ash && usermod -s /bin/zsh ${USER}

      RUN chown -R ${USER} /oh-my-zsh

      RUN if [ "$HELM_VERSION" != "" ]; then for version in $HELM_VERSION; do ( echo "---"; echo "install HELM version $version ..."; sudo helmenv install "$version"; sudo helmenv local "$version"; ) >> /tmp/boot.log 2>&1; done; fi

      RUN if  [ "$TERRAFORM_VERSION" != "" ]; then for version in $TERRAFORM_VERSION; do ( echo "---"; echo "install TERRAFORM version $version ..."; sudo tfenv install "$version"; sudo tfenv use "$version";) >> /tmp/boot.log 2>&1; done; fi

      RUN if [ "$TERRAGRUNT_VERSION" != "" ]; then for version in $TERRAGRUNT_VERSION; do ( echo "---"; echo "install TERRAGRUNT version $version ..."; sudo tgenv install "$version"; sudo tgenv use "$version") >> /tmp/boot.log 2>&1; done; fi


      COPY entrypoint.sh /entrypoint.sh
      COPY aws-assume.sh /usr/local/bin/aws-assume.sh

      ### set user
      USER ${USER:-user}

      ### apply helmenv 3.1.1 and install helmdiff
      RUN touch ~/.zshrc

      ENTRYPOINT ["/entrypoint.sh"]
    confdest: /tmp/tooling/Dockerfile
    confperm: 0644
  - type: "conf"
    confdata: |
      version: "3"
      services:
        tooling:
          volumes:
            - ${HOME}/Projects/dot_files:${HOME}
            - ${HOME}/Projects/dot_files:/home/${USER}
            - ${HOME}/Projects:/home/${USER}/Projects
            - ${HOME}/Projects:${HOME}/Projects
            - /var/run/docker.sock:/var/run/docker.sock
    confdest: /tmp/tooling/volumes-mac.yaml
    confperm: 0644
  - type: "conf"
    confdata: |
      version: "3"
      services:
        tooling:
          privileged: true
          entrypoint: "/entrypoint.sh"
          network_mode: "host"
          container_name: "tooling"
          hostname: "tooling"
          build:
            context: .
            args:
              IMAGE: ghcr.io/lanixx-hh/tooling-base
              TAG: latest
              USER: ${USER:-user}
              UID: ${UID:-1000}
              TERRAFORM_VERSION: '0.11.14 0.12.30'
              TERRAGRUNT_VERSION: '0.25.5 0.25.3'
              HELM_VERSION: '3.5.0'
          environment:
            SHELL: /bin/zsh
            KUBECONFIG: /home/${USER}/.kube/config
            SSH_PRIVATE_KEY_FILE: /home/${USER}/.ssh/id_rsa
            SSO_PROFILE: ${SSO_PROFILE:-}
    confdest: /tmp/tooling/docker-compose.yaml
    confperm: 0644
  - type: "shell"
    name: "lsh"
    desc: "start tooling"
    values:
      - export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/anatolilichii/.local/bin &&
      - ( export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/anatolilichii/.local/bin &&
      - docker pull ghcr.io/lanixx-hh/tooling-base:latest &&
      - docker-compose
      - -f /tmp/tooling/docker-compose.yaml
      - --project-directory /tmp/tooling
      - build tooling) ;
      - export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/anatolilichii/.local/bin &&
      - docker-compose
      - -f /tmp/tooling/volumes-mac.yaml
      - -f /tmp/tooling/docker-compose.yaml
      - --project-directory /tmp/tooling
      - run tooling
```
