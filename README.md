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
        IMAGE: ghcr.io/lanixx-hh/tooling-base
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

get runfromyaml and example tooling yaml
~~~shell
curl --silent --location "https://github.com/lanixx-hh/runfromyaml/releases/latest/download/runfromyaml-$(uname -s)-$(uname -m).tar.gz" | tar xz
curl --silent --location --output tooling.yaml https://raw.githubusercontent.com/LANIXX-HH/runfromyaml/master/examples/tooling.yaml
~~~

run tooling image: 
~~~shell
./runfromyaml -file tooling.yaml
~~~
