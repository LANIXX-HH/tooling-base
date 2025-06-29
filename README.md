# Tooling base

What's it for?

This is a toolkit from our team which may help you. Firstly, it is a working example (we do not give a 100% guarantee of course and any feedback is welcome!), an OS-independent installation that can be used immediately and secondly it is a collection of utilities and an example of how to install them (see Dockerfile recipe).

## What can I find here?

based on alpine:edge

base packages:

* **Kubernetes tools:**
  * kubectl - Kubernetes command-line tool
  * kubectx (alias: kx) - switch between Kubernetes contexts
  * kubens (alias: kn) - switch between Kubernetes namespaces
  * eksctl - AWS EKS cluster management tool
  * kind - run local Kubernetes clusters using Docker
  * helmfile - declarative spec for deploying Helm charts
  * helm - Kubernetes package manager

* **AWS tools:**
  * awscli v2 - AWS command line interface
  * aws-iam-authenticator - AWS IAM authenticator for Kubernetes
  * aws cdk - AWS Cloud Development Kit
  * session manager - AWS Systems Manager Session Manager plugin
  * aws-vault - secure credential storage and access

* **AWS SSO wrappers:**
  * aws-sso.py and additional help wrapper for shell session
  * granted / assume - simplified AWS credential management

* **Infrastructure as Code:**
  * terraform with tfenv - infrastructure provisioning tool with version manager
  * terragrunt with tgenv - Terraform wrapper with version manager
  * opentofu - open-source Terraform alternative
  * tflint - Terraform linter
  * tfsec - Terraform security scanner
  * terraform-docs - generate documentation from Terraform modules
  * terraform-graph-beautifier - beautify Terraform dependency graphs

* **Container tools:**
  * docker - container runtime
  * docker-compose - multi-container Docker applications

* **Development tools:**
  * git with extensions:
    * hub - GitHub command-line tool
    * scripts: git-pair, git-solo, git-authors, git-time, git-pp, git-changelog
  * nvim (neovim) - modern Vim-based editor
  * direnv - environment variable management per directory
  * just - command runner (alternative to make)

* **Data processing:**
  * yq - YAML/JSON/XML processor
  * jid - JSON incremental digger (interactive JSON explorer)
  * miller (mlr) - data processing tool for CSV, TSV, JSON, etc.
  * jq - JSON processor (included in base system)

* **Shell and terminal:**
  * zsh with oh-my-zsh, zsh-completions, zsh-autosuggestions
  * powerlevel9k/powerlevel10k themes
  * zsh-syntax-highlighting
  * kube-ps1 - Kubernetes prompt for bash/zsh
  * zellij - terminal multiplexer

* **CI/CD and automation:**
  * fly - Concourse CI command-line tool

* **Messaging and streaming:**
  * kafka - Apache Kafka with Scala runtime

* **AI and productivity:**
  * Amazon Q - AI-powered assistant for developers

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
* git-pp – pretty print git log with enhanced formatting
* git-changelog – generate changelog from git commits
* git-authors – list all authors in the repository
* git-time – show time-based git statistics
* yq – YAML/JSON/XML processor - like jq but for YAML files
* mlr (miller) – data processing tool for CSV, TSV, JSON and other structured data formats
* just – command runner similar to make but with simpler syntax
* direnv – automatically loads environment variables when entering directories
* nvim – modern Vim-based text editor with enhanced features
* zellij – terminal multiplexer (alternative to tmux/screen) with modern UI
* hub – GitHub command-line tool for repository management
* kind – run local Kubernetes clusters using Docker containers
* helmfile – declarative specification for deploying Helm charts
* terraform-docs – generate documentation from Terraform modules automatically
* terraform-graph-beautifier – create beautiful dependency graphs from Terraform plans
* tflint – Terraform linter to find possible errors and enforce best practices
* tfsec – security scanner for Terraform code to identify potential security issues
* tfenv – Terraform version manager to switch between different Terraform versions
* tgenv – Terragrunt version manager to switch between different Terragrunt versions
* aws-vault – secure credential storage and access for AWS
* aws-iam-authenticator – AWS IAM authenticator for Kubernetes clusters
* opentofu – open-source Terraform alternative with full compatibility
* granted/assume – simplified AWS credential management with interactive profile selection
* Amazon Q – AI-powered assistant for developers with code suggestions and explanations

###Kafka Tools
* kafka-console-producer – command-line tool to produce messages to Kafka topics
* kafka-console-consumer – command-line tool to consume messages from Kafka topics
* kafka-topics – manage Kafka topics (create, list, describe, delete)
* kafka-configs – manage Kafka configurations

###System and Database Tools
* **System utilities:**
  * htop – interactive process viewer
  * nmap – network discovery and security auditing tool
  * strace – system call tracer for debugging
  * bind-utils – DNS lookup utilities (dig, nslookup)
  * openssl – cryptography toolkit
  * rsync – file synchronization tool
  * unzip/tar – archive extraction tools

* **Database clients:**
  * mariadb105 – MySQL/MariaDB command-line client
  * postgresql16 – PostgreSQL command-line client

* **Communication tools:**
  * mailx – command-line mail client
  * mutt – text-based email client
  * openldap-clients – LDAP client utilities

* **Text processing:**
  * sed – stream editor for filtering and transforming text
  * grep – text search utility
  * less – file pager
  * vim/nano – text editors

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

### full example: tooling yaml wrapper + runfromyaml binary

get runfromyaml and example tooling yaml and run it
~~~shell
curl --silent --location "https://github.com/lanixx-hh/runfromyaml/releases/latest/download/runfromyaml-$(uname -s)-$(uname -m).tar.gz" | tar xz
curl --silent --location --output tooling.yaml https://raw.githubusercontent.com/LANIXX-HH/runfromyaml/master/examples/tooling.yaml
./runfromyaml -file tooling.yaml
~~~
