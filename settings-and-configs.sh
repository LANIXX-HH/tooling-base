#!/bin/bash 

#vim
echo "set mouse=" >> /etc/vim/vimrc
echo "set ttymouse=" >> /etc/vim/vimrc

rm -rf /etc/zsh*

# zshrc
mkdir -p /etc/zsh 

## override zshrc
echo 'export TERM="xterm-256color"' > /etc/zsh/zshrc

## create new config from template
cat /oh-my-zsh/templates/zshrc.zsh-template >> /etc/zsh/zshrc

## replace settings
sed -i 's|robbyrussell|agnoster|g' /etc/zsh/zshrc
sed -i 's|^export ZSH=.*$|export ZSH=/oh-my-zsh|g' /etc/zsh/zshrc
sed -i 's|^plugins=(.*)$|plugins=(git zsh-completions zsh-autosuggestions kube-ps1 kubectl terraform kops cp golang docker docker-compose)|g' /etc/zsh/zshrc

## set additional settings
( echo 'export EDITOR="nvim"';
echo 'source /powerlevel9k/powerlevel9k.zsh-theme';
echo 'source /powerlevel10k/powerlevel10k.zsh-theme';
echo 'source /usr/local/bin/kube-ps1.sh';
echo 'TranslateWheelToCursor=off';
echo 'alias k="kubectl"';
echo 'alias kx="kubectx"';
echo 'alias kn="kubens"';
echo 'alias d="docker"';
echo 'alias dc="docker-compose"';
echo 'source /zsh-syntax-highlighting/zsh-syntax-highlighting.zsh';
echo 'eval "$(direnv hook zsh)"'; 
echo 'source /powerlevel10k/.p10k.zsh' ) >> /etc/zsh/zshrc

cat << EOF | base64 -d > /powerlevel10k/.p10k.zsh
J2J1aWx0aW4nICdsb2NhbCcgJy1hJyAncDEwa19jb25maWdfb3B0cycKW1sgISAtbyAnYWxpYXNl
cycgICAgICAgICBdXSB8fCBwMTBrX2NvbmZpZ19vcHRzKz0oJ2FsaWFzZXMnKQpbWyAhIC1vICdz
aF9nbG9iJyAgICAgICAgIF1dIHx8IHAxMGtfY29uZmlnX29wdHMrPSgnc2hfZ2xvYicpCltbICEg
LW8gJ25vX2JyYWNlX2V4cGFuZCcgXV0gfHwgcDEwa19jb25maWdfb3B0cys9KCdub19icmFjZV9l
eHBhbmQnKQonYnVpbHRpbicgJ3NldG9wdCcgJ25vX2FsaWFzZXMnICdub19zaF9nbG9iJyAnYnJh
Y2VfZXhwYW5kJwooKSB7CiAgZW11bGF0ZSAtTCB6c2ggLW8gZXh0ZW5kZWRfZ2xvYgogIHVuc2V0
IC1tICcoUE9XRVJMRVZFTDlLXyp8REVGQVVMVF9VU0VSKX5QT1dFUkxFVkVMOUtfR0lUU1RBVFVT
X0RJUicKICBhdXRvbG9hZCAtVXogaXMtYXQtbGVhc3QgJiYgaXMtYXQtbGVhc3QgNS4xIHx8IHJl
dHVybgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0xFRlRfUFJPTVBUX0VMRU1FTlRTPSgKICAg
IGRpciAgICAgICAgICAgICAgICAgICAgICMgY3VycmVudCBkaXJlY3RvcnkKICAgIHZjcyAgICAg
ICAgICAgICAgICAgICAgICMgZ2l0IHN0YXR1cwogICAgbmV3bGluZSAgICAgICAgICAgICAgICAg
IyBcbgogICAgcHJvbXB0X2NoYXIgICAgICAgICAgICAgIyBwcm9tcHQgc3ltYm9sCiAgKQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1JJR0hUX1BST01QVF9FTEVNRU5UUz0oCiAgICBzdGF0dXMg
ICAgICAgICAgICAgICAgICAjIGV4aXQgY29kZSBvZiB0aGUgbGFzdCBjb21tYW5kCiAgICBjb21t
YW5kX2V4ZWN1dGlvbl90aW1lICAjIGR1cmF0aW9uIG9mIHRoZSBsYXN0IGNvbW1hbmQKICAgIGJh
Y2tncm91bmRfam9icyAgICAgICAgICMgcHJlc2VuY2Ugb2YgYmFja2dyb3VuZCBqb2JzCiAgICBk
aXJlbnYgICAgICAgICAgICAgICAgICAjIGRpcmVudiBzdGF0dXMgKGh0dHBzOi8vZGlyZW52Lm5l
dC8pCiAgICBhc2RmICAgICAgICAgICAgICAgICAgICAjIGFzZGYgdmVyc2lvbiBtYW5hZ2VyICho
dHRwczovL2dpdGh1Yi5jb20vYXNkZi12bS9hc2RmKQogICAgdmlydHVhbGVudiAgICAgICAgICAg
ICAgIyBweXRob24gdmlydHVhbCBlbnZpcm9ubWVudCAoaHR0cHM6Ly9kb2NzLnB5dGhvbi5vcmcv
My9saWJyYXJ5L3ZlbnYuaHRtbCkKICAgIGFuYWNvbmRhICAgICAgICAgICAgICAgICMgY29uZGEg
ZW52aXJvbm1lbnQgKGh0dHBzOi8vY29uZGEuaW8vKQogICAgcHllbnYgICAgICAgICAgICAgICAg
ICAgIyBweXRob24gZW52aXJvbm1lbnQgKGh0dHBzOi8vZ2l0aHViLmNvbS9weWVudi9weWVudikK
ICAgIGdvZW52ICAgICAgICAgICAgICAgICAgICMgZ28gZW52aXJvbm1lbnQgKGh0dHBzOi8vZ2l0
aHViLmNvbS9zeW5kYmcvZ29lbnYpCiAgICBub2RlbnYgICAgICAgICAgICAgICAgICAjIG5vZGUu
anMgdmVyc2lvbiBmcm9tIG5vZGVudiAoaHR0cHM6Ly9naXRodWIuY29tL25vZGVudi9ub2RlbnYp
CiAgICBudm0gICAgICAgICAgICAgICAgICAgICAjIG5vZGUuanMgdmVyc2lvbiBmcm9tIG52bSAo
aHR0cHM6Ly9naXRodWIuY29tL252bS1zaC9udm0pCiAgICBub2RlZW52ICAgICAgICAgICAgICAg
ICAjIG5vZGUuanMgZW52aXJvbm1lbnQgKGh0dHBzOi8vZ2l0aHViLmNvbS9la2FsaW5pbi9ub2Rl
ZW52KQogICAgcmJlbnYgICAgICAgICAgICAgICAgICAgIyBydWJ5IHZlcnNpb24gZnJvbSByYmVu
diAoaHR0cHM6Ly9naXRodWIuY29tL3JiZW52L3JiZW52KQogICAgcnZtICAgICAgICAgICAgICAg
ICAgICAgIyBydWJ5IHZlcnNpb24gZnJvbSBydm0gKGh0dHBzOi8vcnZtLmlvKQogICAgZnZtICAg
ICAgICAgICAgICAgICAgICAgIyBmbHV0dGVyIHZlcnNpb24gbWFuYWdlbWVudCAoaHR0cHM6Ly9n
aXRodWIuY29tL2xlb2FmYXJpYXMvZnZtKQogICAgbHVhZW52ICAgICAgICAgICAgICAgICAgIyBs
dWEgdmVyc2lvbiBmcm9tIGx1YWVudiAoaHR0cHM6Ly9naXRodWIuY29tL2NlaG9mZm1hbi9sdWFl
bnYpCiAgICBqZW52ICAgICAgICAgICAgICAgICAgICAjIGphdmEgdmVyc2lvbiBmcm9tIGplbnYg
KGh0dHBzOi8vZ2l0aHViLmNvbS9qZW52L2plbnYpCiAgICBwbGVudiAgICAgICAgICAgICAgICAg
ICAjIHBlcmwgdmVyc2lvbiBmcm9tIHBsZW52IChodHRwczovL2dpdGh1Yi5jb20vdG9rdWhpcm9t
L3BsZW52KQogICAgcGhwZW52ICAgICAgICAgICAgICAgICAgIyBwaHAgdmVyc2lvbiBmcm9tIHBo
cGVudiAoaHR0cHM6Ly9naXRodWIuY29tL3BocGVudi9waHBlbnYpCiAgICBzY2FsYWVudiAgICAg
ICAgICAgICAgICAjIHNjYWxhIHZlcnNpb24gZnJvbSBzY2FsYWVudiAoaHR0cHM6Ly9naXRodWIu
Y29tL3NjYWxhZW52L3NjYWxhZW52KQogICAgaGFza2VsbF9zdGFjayAgICAgICAgICAgIyBoYXNr
ZWxsIHZlcnNpb24gZnJvbSBzdGFjayAoaHR0cHM6Ly9oYXNrZWxsc3RhY2sub3JnLykKICAgIGt1
YmVjb250ZXh0ICAgICAgICAgICAgICMgY3VycmVudCBrdWJlcm5ldGVzIGNvbnRleHQgKGh0dHBz
Oi8va3ViZXJuZXRlcy5pby8pCiAgICB0ZXJyYWZvcm0gICAgICAgICAgICAgICAjIHRlcnJhZm9y
bSB3b3Jrc3BhY2UgKGh0dHBzOi8vd3d3LnRlcnJhZm9ybS5pbykKICAgIGF3cyAgICAgICAgICAg
ICAgICAgICAgICMgYXdzIHByb2ZpbGUgKGh0dHBzOi8vZG9jcy5hd3MuYW1hem9uLmNvbS9jbGkv
bGF0ZXN0L3VzZXJndWlkZS9jbGktY29uZmlndXJlLXByb2ZpbGVzLmh0bWwpCiAgICBhd3NfZWJf
ZW52ICAgICAgICAgICAgICAjIGF3cyBlbGFzdGljIGJlYW5zdGFsayBlbnZpcm9ubWVudCAoaHR0
cHM6Ly9hd3MuYW1hem9uLmNvbS9lbGFzdGljYmVhbnN0YWxrLykKICAgIGF6dXJlICAgICAgICAg
ICAgICAgICAgICMgYXp1cmUgYWNjb3VudCBuYW1lIChodHRwczovL2RvY3MubWljcm9zb2Z0LmNv
bS9lbi11cy9jbGkvYXp1cmUpCiAgICBnY2xvdWQgICAgICAgICAgICAgICAgICAjIGdvb2dsZSBj
bG91ZCBjbGkgYWNjb3VudCBhbmQgcHJvamVjdCAoaHR0cHM6Ly9jbG91ZC5nb29nbGUuY29tLykK
ICAgIGdvb2dsZV9hcHBfY3JlZCAgICAgICAgICMgZ29vZ2xlIGFwcGxpY2F0aW9uIGNyZWRlbnRp
YWxzIChodHRwczovL2Nsb3VkLmdvb2dsZS5jb20vZG9jcy9hdXRoZW50aWNhdGlvbi9wcm9kdWN0
aW9uKQogICAgY29udGV4dCAgICAgICAgICAgICAgICAgIyB1c2VyQGhvc3RuYW1lCiAgICBub3Jk
dnBuICAgICAgICAgICAgICAgICAjIG5vcmR2cG4gY29ubmVjdGlvbiBzdGF0dXMsIGxpbnV4IG9u
bHkgKGh0dHBzOi8vbm9yZHZwbi5jb20vKQogICAgcmFuZ2VyICAgICAgICAgICAgICAgICAgIyBy
YW5nZXIgc2hlbGwgKGh0dHBzOi8vZ2l0aHViLmNvbS9yYW5nZXIvcmFuZ2VyKQogICAgbm5uICAg
ICAgICAgICAgICAgICAgICAgIyBubm4gc2hlbGwgKGh0dHBzOi8vZ2l0aHViLmNvbS9qYXJ1bi9u
bm4pCiAgICB2aW1fc2hlbGwgICAgICAgICAgICAgICAjIHZpbSBzaGVsbCBpbmRpY2F0b3IgKDpz
aCkKICAgIG1pZG5pZ2h0X2NvbW1hbmRlciAgICAgICMgbWlkbmlnaHQgY29tbWFuZGVyIHNoZWxs
IChodHRwczovL21pZG5pZ2h0LWNvbW1hbmRlci5vcmcvKQogICAgbml4X3NoZWxsICAgICAgICAg
ICAgICAgIyBuaXggc2hlbGwgKGh0dHBzOi8vbml4b3Mub3JnL25peG9zL25peC1waWxscy9kZXZl
bG9waW5nLXdpdGgtbml4LXNoZWxsLmh0bWwpCiAgICB0b2RvICAgICAgICAgICAgICAgICAgICAj
IHRvZG8gaXRlbXMgKGh0dHBzOi8vZ2l0aHViLmNvbS90b2RvdHh0L3RvZG8udHh0LWNsaSkKICAg
IHRpbWV3YXJyaW9yICAgICAgICAgICAgICMgdGltZXdhcnJpb3IgdHJhY2tpbmcgc3RhdHVzICho
dHRwczovL3RpbWV3YXJyaW9yLm5ldC8pCiAgICB0YXNrd2FycmlvciAgICAgICAgICAgICAjIHRh
c2t3YXJyaW9yIHRhc2sgY291bnQgKGh0dHBzOi8vdGFza3dhcnJpb3Iub3JnLykKICAgIHRpbWUg
ICAgICAgICAgICAgICAgICAgICMgY3VycmVudCB0aW1lCiAgICBuZXdsaW5lICAgICAgICAgICAg
ICAgICAjIFxuCiAgKQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX01PREU9YXNjaWkKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19JQ09OX1BBRERJTkc9bm9uZQogIHR5cGVzZXQgLWcgUE9XRVJM
RVZFTDlLX0lDT05fQkVGT1JFX0NPTlRFTlQ9CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUFJP
TVBUX0FERF9ORVdMSU5FPXRydWUKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19NVUxUSUxJTkVf
RklSU1RfUFJPTVBUX1BSRUZJWD0KICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19NVUxUSUxJTkVf
TkVXTElORV9QUk9NUFRfUFJFRklYPQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX01VTFRJTElO
RV9MQVNUX1BST01QVF9QUkVGSVg9CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTVVMVElMSU5F
X0ZJUlNUX1BST01QVF9TVUZGSVg9CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTVVMVElMSU5F
X05FV0xJTkVfUFJPTVBUX1NVRkZJWD0KICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19NVUxUSUxJ
TkVfTEFTVF9QUk9NUFRfU1VGRklYPQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX01VTFRJTElO
RV9GSVJTVF9QUk9NUFRfR0FQX0NIQVI9Jy0nCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTVVM
VElMSU5FX0ZJUlNUX1BST01QVF9HQVBfQkFDS0dST1VORD0KICB0eXBlc2V0IC1nIFBPV0VSTEVW
RUw5S19NVUxUSUxJTkVfTkVXTElORV9QUk9NUFRfR0FQX0JBQ0tHUk9VTkQ9CiAgaWYgW1sgJFBP
V0VSTEVWRUw5S19NVUxUSUxJTkVfRklSU1RfUFJPTVBUX0dBUF9DSEFSICE9ICcgJyBdXTsgdGhl
bgogICAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTVVMVElMSU5FX0ZJUlNUX1BST01QVF9HQVBf
Rk9SRUdST1VORD0yNDAKICAgIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0VNUFRZX0xJTkVfTEVG
VF9QUk9NUFRfRklSU1RfU0VHTUVOVF9FTkRfU1lNQk9MPScleyV9JwogICAgdHlwZXNldCAtZyBQ
T1dFUkxFVkVMOUtfRU1QVFlfTElORV9SSUdIVF9QUk9NUFRfRklSU1RfU0VHTUVOVF9TVEFSVF9T
WU1CT0w9JyV7JX0nCiAgZmkKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19CQUNLR1JPVU5EPTIz
NgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0xFRlRfU1VCU0VHTUVOVF9TRVBBUkFUT1I9JyUy
NDRGfCcKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19SSUdIVF9TVUJTRUdNRU5UX1NFUEFSQVRP
Uj0nJTI0NEZ8JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0xFRlRfU0VHTUVOVF9TRVBBUkFU
T1I9JycKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19SSUdIVF9TRUdNRU5UX1NFUEFSQVRPUj0n
JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0xFRlRfUFJPTVBUX0xBU1RfU0VHTUVOVF9FTkRf
U1lNQk9MPScnCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUklHSFRfUFJPTVBUX0ZJUlNUX1NF
R01FTlRfU1RBUlRfU1lNQk9MPScnCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTEVGVF9QUk9N
UFRfRklSU1RfU0VHTUVOVF9TVEFSVF9TWU1CT0w9JycKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19SSUdIVF9QUk9NUFRfTEFTVF9TRUdNRU5UX0VORF9TWU1CT0w9JycKICB0eXBlc2V0IC1nIFBP
V0VSTEVWRUw5S19FTVBUWV9MSU5FX0xFRlRfUFJPTVBUX0xBU1RfU0VHTUVOVF9FTkRfU1lNQk9M
PQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX09TX0lDT05fRk9SRUdST1VORD0yNTUKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19QUk9NUFRfQ0hBUl9CQUNLR1JPVU5EPQogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX1BST01QVF9DSEFSX09LX3tWSUlOUyxWSUNNRCxWSVZJUyxWSU9XUn1fRk9S
RUdST1VORD03NgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1BST01QVF9DSEFSX0VSUk9SX3tW
SUlOUyxWSUNNRCxWSVZJUyxWSU9XUn1fRk9SRUdST1VORD0xOTYKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19QUk9NUFRfQ0hBUl97T0ssRVJST1J9X1ZJSU5TX0NPTlRFTlRfRVhQQU5TSU9OPSc+
JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1BST01QVF9DSEFSX3tPSyxFUlJPUn1fVklDTURf
Q09OVEVOVF9FWFBBTlNJT049JzwnCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUFJPTVBUX0NI
QVJfe09LLEVSUk9SfV9WSVZJU19DT05URU5UX0VYUEFOU0lPTj0nVicKICB0eXBlc2V0IC1nIFBP
V0VSTEVWRUw5S19QUk9NUFRfQ0hBUl97T0ssRVJST1J9X1ZJT1dSX0NPTlRFTlRfRVhQQU5TSU9O
PSdeJwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1BST01QVF9DSEFSX09WRVJXUklURV9TVEFU
RT10cnVlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUFJPTVBUX0NIQVJfTEVGVF9QUk9NUFRf
TEFTVF9TRUdNRU5UX0VORF9TWU1CT0w9CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUFJPTVBU
X0NIQVJfTEVGVF9QUk9NUFRfRklSU1RfU0VHTUVOVF9TVEFSVF9TWU1CT0w9CiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfUFJPTVBUX0NIQVJfTEVGVF97TEVGVCxSSUdIVH1fV0hJVEVTUEFDRT0K
ICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ESVJfRk9SRUdST1VORD0zMQogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX1NIT1JURU5fU1RSQVRFR1k9dHJ1bmNhdGVfdG9fdW5pcXVlCiAgdHlwZXNl
dCAtZyBQT1dFUkxFVkVMOUtfU0hPUlRFTl9ERUxJTUlURVI9CiAgdHlwZXNldCAtZyBQT1dFUkxF
VkVMOUtfRElSX1NIT1JURU5FRF9GT1JFR1JPVU5EPTEwMwogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX0RJUl9BTkNIT1JfRk9SRUdST1VORD0zOQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0RJ
Ul9BTkNIT1JfQk9MRD10cnVlCiAgbG9jYWwgYW5jaG9yX2ZpbGVzPSgKICAgIC5ienIKICAgIC5j
aXRjCiAgICAuZ2l0CiAgICAuaGcKICAgIC5ub2RlLXZlcnNpb24KICAgIC5weXRob24tdmVyc2lv
bgogICAgLmdvLXZlcnNpb24KICAgIC5ydWJ5LXZlcnNpb24KICAgIC5sdWEtdmVyc2lvbgogICAg
LmphdmEtdmVyc2lvbgogICAgLnBlcmwtdmVyc2lvbgogICAgLnBocC12ZXJzaW9uCiAgICAudG9v
bC12ZXJzaW9uCiAgICAuc2hvcnRlbl9mb2xkZXJfbWFya2VyCiAgICAuc3ZuCiAgICAudGVycmFm
b3JtCiAgICBDVlMKICAgIENhcmdvLnRvbWwKICAgIGNvbXBvc2VyLmpzb24KICAgIGdvLm1vZAog
ICAgcGFja2FnZS5qc29uCiAgICBzdGFjay55YW1sCiAgKQogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX1NIT1JURU5fRk9MREVSX01BUktFUj0iKCR7KGo6fDopYW5jaG9yX2ZpbGVzfSkiCiAgdHlw
ZXNldCAtZyBQT1dFUkxFVkVMOUtfRElSX1RSVU5DQVRFX0JFRk9SRV9NQVJLRVI9ZmFsc2UKICB0
eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19TSE9SVEVOX0RJUl9MRU5HVEg9MQogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX0RJUl9NQVhfTEVOR1RIPTgwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtf
RElSX01JTl9DT01NQU5EX0NPTFVNTlM9NDAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ESVJf
TUlOX0NPTU1BTkRfQ09MVU1OU19QQ1Q9NTAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ESVJf
SFlQRVJMSU5LPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfRElSX1NIT1dfV1JJVEFC
TEU9djMKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ESVJfQ0xBU1NFUz0oKQogIHR5cGVzZXQg
LWcgUE9XRVJMRVZFTDlLX1ZDU19CUkFOQ0hfSUNPTj0KICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19WQ1NfVU5UUkFDS0VEX0lDT049Jz8nCiAgZnVuY3Rpb24gbXlfZ2l0X2Zvcm1hdHRlcigpIHsK
ICAgIGVtdWxhdGUgLUwgenNoCiAgICBpZiBbWyAtbiAkUDlLX0NPTlRFTlQgXV07IHRoZW4KICAg
ICAgdHlwZXNldCAtZyBteV9naXRfZm9ybWF0PSRQOUtfQ09OVEVOVAogICAgICByZXR1cm4KICAg
IGZpCiAgICBpZiAoKCAkMSApKTsgdGhlbgogICAgICBsb2NhbCAgICAgICBtZXRhPSclMjQ2Ricg
ICMgZ3JleSBmb3JlZ3JvdW5kCiAgICAgIGxvY2FsICAgICAgY2xlYW49JyU3NkYnICAgIyBncmVl
biBmb3JlZ3JvdW5kCiAgICAgIGxvY2FsICAgbW9kaWZpZWQ9JyUxNzhGJyAgIyB5ZWxsb3cgZm9y
ZWdyb3VuZAogICAgICBsb2NhbCAgdW50cmFja2VkPSclMzlGJyAgICMgYmx1ZSBmb3JlZ3JvdW5k
CiAgICAgIGxvY2FsIGNvbmZsaWN0ZWQ9JyUxOTZGJyAgIyByZWQgZm9yZWdyb3VuZAogICAgZWxz
ZQogICAgICBsb2NhbCAgICAgICBtZXRhPSclMjQ0RicgICMgZ3JleSBmb3JlZ3JvdW5kCiAgICAg
IGxvY2FsICAgICAgY2xlYW49JyUyNDRGJyAgIyBncmV5IGZvcmVncm91bmQKICAgICAgbG9jYWwg
ICBtb2RpZmllZD0nJTI0NEYnICAjIGdyZXkgZm9yZWdyb3VuZAogICAgICBsb2NhbCAgdW50cmFj
a2VkPSclMjQ0RicgICMgZ3JleSBmb3JlZ3JvdW5kCiAgICAgIGxvY2FsIGNvbmZsaWN0ZWQ9JyUy
NDRGJyAgIyBncmV5IGZvcmVncm91bmQKICAgIGZpCiAgICBsb2NhbCByZXMKICAgIGlmIFtbIC1u
ICRWQ1NfU1RBVFVTX0xPQ0FMX0JSQU5DSCBdXTsgdGhlbgogICAgICBsb2NhbCBicmFuY2g9JHso
VilWQ1NfU1RBVFVTX0xPQ0FMX0JSQU5DSH0KICAgICAgKCggJCNicmFuY2ggPiAzMiApKSAmJiBi
cmFuY2hbMTMsLTEzXT0iLi4iICAjIDwtLSB0aGlzIGxpbmUKICAgICAgcmVzKz0iJHtjbGVhbn0k
eyhnOjopUE9XRVJMRVZFTDlLX1ZDU19CUkFOQ0hfSUNPTn0ke2JyYW5jaC8vXCUvJSV9IgogICAg
ZmkKICAgIGlmIFtbIC1uICRWQ1NfU1RBVFVTX1RBRwogICAgICAgICAgJiYgLXogJFZDU19TVEFU
VVNfTE9DQUxfQlJBTkNIICAjIDwtLSB0aGlzIGxpbmUKICAgICAgICBdXTsgdGhlbgogICAgICBs
b2NhbCB0YWc9JHsoVilWQ1NfU1RBVFVTX1RBR30KICAgICAgKCggJCN0YWcgPiAzMiApKSAmJiB0
YWdbMTMsLTEzXT0iLi4iICAjIDwtLSB0aGlzIGxpbmUKICAgICAgcmVzKz0iJHttZXRhfSMke2Ns
ZWFufSR7dGFnLy9cJS8lJX0iCiAgICBmaQogICAgW1sgLXogJFZDU19TVEFUVVNfTE9DQUxfQlJB
TkNIICYmIC16ICRWQ1NfU1RBVFVTX0xPQ0FMX0JSQU5DSCBdXSAmJiAgIyA8LS0gdGhpcyBsaW5l
CiAgICAgIHJlcys9IiR7bWV0YX1AJHtjbGVhbn0ke1ZDU19TVEFUVVNfQ09NTUlUWzEsOF19Igog
ICAgaWYgW1sgLW4gJHtWQ1NfU1RBVFVTX1JFTU9URV9CUkFOQ0g6IyRWQ1NfU1RBVFVTX0xPQ0FM
X0JSQU5DSH0gXV07IHRoZW4KICAgICAgcmVzKz0iJHttZXRhfToke2NsZWFufSR7KFYpVkNTX1NU
QVRVU19SRU1PVEVfQlJBTkNILy9cJS8lJX0iCiAgICBmaQogICAgKCggVkNTX1NUQVRVU19DT01N
SVRTX0JFSElORCApKSAmJiByZXMrPSIgJHtjbGVhbn08JHtWQ1NfU1RBVFVTX0NPTU1JVFNfQkVI
SU5EfSIKICAgICgoIFZDU19TVEFUVVNfQ09NTUlUU19BSEVBRCAmJiAhVkNTX1NUQVRVU19DT01N
SVRTX0JFSElORCApKSAmJiByZXMrPSIgIgogICAgKCggVkNTX1NUQVRVU19DT01NSVRTX0FIRUFE
ICApKSAmJiByZXMrPSIke2NsZWFufT4ke1ZDU19TVEFUVVNfQ09NTUlUU19BSEVBRH0iCiAgICAo
KCBWQ1NfU1RBVFVTX1BVU0hfQ09NTUlUU19CRUhJTkQgKSkgJiYgcmVzKz0iICR7Y2xlYW59PC0k
e1ZDU19TVEFUVVNfUFVTSF9DT01NSVRTX0JFSElORH0iCiAgICAoKCBWQ1NfU1RBVFVTX1BVU0hf
Q09NTUlUU19BSEVBRCAmJiAhVkNTX1NUQVRVU19QVVNIX0NPTU1JVFNfQkVISU5EICkpICYmIHJl
cys9IiAiCiAgICAoKCBWQ1NfU1RBVFVTX1BVU0hfQ09NTUlUU19BSEVBRCAgKSkgJiYgcmVzKz0i
JHtjbGVhbn0tPiR7VkNTX1NUQVRVU19QVVNIX0NPTU1JVFNfQUhFQUR9IgogICAgKCggVkNTX1NU
QVRVU19TVEFTSEVTICAgICAgICApKSAmJiByZXMrPSIgJHtjbGVhbn0qJHtWQ1NfU1RBVFVTX1NU
QVNIRVN9IgogICAgW1sgLW4gJFZDU19TVEFUVVNfQUNUSU9OICAgICBdXSAmJiByZXMrPSIgJHtj
b25mbGljdGVkfSR7VkNTX1NUQVRVU19BQ1RJT059IgogICAgKCggVkNTX1NUQVRVU19OVU1fQ09O
RkxJQ1RFRCApKSAmJiByZXMrPSIgJHtjb25mbGljdGVkfX4ke1ZDU19TVEFUVVNfTlVNX0NPTkZM
SUNURUR9IgogICAgKCggVkNTX1NUQVRVU19OVU1fU1RBR0VEICAgICApKSAmJiByZXMrPSIgJHtt
b2RpZmllZH0rJHtWQ1NfU1RBVFVTX05VTV9TVEFHRUR9IgogICAgKCggVkNTX1NUQVRVU19OVU1f
VU5TVEFHRUQgICApKSAmJiByZXMrPSIgJHttb2RpZmllZH0hJHtWQ1NfU1RBVFVTX05VTV9VTlNU
QUdFRH0iCiAgICAoKCBWQ1NfU1RBVFVTX05VTV9VTlRSQUNLRUQgICkpICYmIHJlcys9IiAke3Vu
dHJhY2tlZH0keyhnOjopUE9XRVJMRVZFTDlLX1ZDU19VTlRSQUNLRURfSUNPTn0ke1ZDU19TVEFU
VVNfTlVNX1VOVFJBQ0tFRH0iCiAgICAoKCBWQ1NfU1RBVFVTX0hBU19VTlNUQUdFRCA9PSAtMSAp
KSAmJiByZXMrPSIgJHttb2RpZmllZH0tIgogICAgdHlwZXNldCAtZyBteV9naXRfZm9ybWF0PSRy
ZXMKICB9CiAgZnVuY3Rpb25zIC1NIG15X2dpdF9mb3JtYXR0ZXIgMj4vZGV2L251bGwKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19WQ1NfTUFYX0lOREVYX1NJWkVfRElSVFk9LTEKICB0eXBlc2V0
IC1nIFBPV0VSTEVWRUw5S19WQ1NfRElTQUJMRURfV09SS0RJUl9QQVRURVJOPSd+JwogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX1ZDU19ESVNBQkxFX0dJVFNUQVRVU19GT1JNQVRUSU5HPXRydWUK
ICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19WQ1NfQ09OVEVOVF9FWFBBTlNJT049JyR7JCgobXlf
Z2l0X2Zvcm1hdHRlcigxKSkpKyR7bXlfZ2l0X2Zvcm1hdH19JwogIHR5cGVzZXQgLWcgUE9XRVJM
RVZFTDlLX1ZDU19MT0FESU5HX0NPTlRFTlRfRVhQQU5TSU9OPSckeyQoKG15X2dpdF9mb3JtYXR0
ZXIoMCkpKSske215X2dpdF9mb3JtYXR9fScKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19WQ1Nf
e1NUQUdFRCxVTlNUQUdFRCxVTlRSQUNLRUQsQ09ORkxJQ1RFRCxDT01NSVRTX0FIRUFELENPTU1J
VFNfQkVISU5EfV9NQVhfTlVNPS0xCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVkNTX1ZJU1VB
TF9JREVOVElGSUVSX0NPTE9SPTc2CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVkNTX0xPQURJ
TkdfVklTVUFMX0lERU5USUZJRVJfQ09MT1I9MjQ0CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtf
VkNTX1ZJU1VBTF9JREVOVElGSUVSX0VYUEFOU0lPTj0KICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19WQ1NfQkFDS0VORFM9KGdpdCkKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19WQ1NfQ0xFQU5f
Rk9SRUdST1VORD03NgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1ZDU19VTlRSQUNLRURfRk9S
RUdST1VORD03NgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1ZDU19NT0RJRklFRF9GT1JFR1JP
VU5EPTE3OAogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1NUQVRVU19FWFRFTkRFRF9TVEFURVM9
dHJ1ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1NUQVRVU19PSz1mYWxzZQogIHR5cGVzZXQg
LWcgUE9XRVJMRVZFTDlLX1NUQVRVU19PS19GT1JFR1JPVU5EPTcwCiAgdHlwZXNldCAtZyBQT1dF
UkxFVkVMOUtfU1RBVFVTX09LX1ZJU1VBTF9JREVOVElGSUVSX0VYUEFOU0lPTj0nb2snCiAgdHlw
ZXNldCAtZyBQT1dFUkxFVkVMOUtfU1RBVFVTX09LX1BJUEU9dHJ1ZQogIHR5cGVzZXQgLWcgUE9X
RVJMRVZFTDlLX1NUQVRVU19PS19QSVBFX0ZPUkVHUk9VTkQ9NzAKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19TVEFUVVNfT0tfUElQRV9WSVNVQUxfSURFTlRJRklFUl9FWFBBTlNJT049J29rJwog
IHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1NUQVRVU19FUlJPUj1mYWxzZQogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX1NUQVRVU19FUlJPUl9GT1JFR1JPVU5EPTE2MAogIHR5cGVzZXQgLWcgUE9X
RVJMRVZFTDlLX1NUQVRVU19FUlJPUl9WSVNVQUxfSURFTlRJRklFUl9FWFBBTlNJT049J2VycicK
ICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19TVEFUVVNfRVJST1JfU0lHTkFMPXRydWUKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19TVEFUVVNfRVJST1JfU0lHTkFMX0ZPUkVHUk9VTkQ9MTYwCiAg
dHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfU1RBVFVTX1ZFUkJPU0VfU0lHTkFNRT1mYWxzZQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1NUQVRVU19FUlJPUl9TSUdOQUxfVklTVUFMX0lERU5USUZJ
RVJfRVhQQU5TSU9OPQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1NUQVRVU19FUlJPUl9QSVBF
PXRydWUKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19TVEFUVVNfRVJST1JfUElQRV9GT1JFR1JP
VU5EPTE2MAogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1NUQVRVU19FUlJPUl9QSVBFX1ZJU1VB
TF9JREVOVElGSUVSX0VYUEFOU0lPTj0nZXJyJwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0NP
TU1BTkRfRVhFQ1VUSU9OX1RJTUVfVEhSRVNIT0xEPTMKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19DT01NQU5EX0VYRUNVVElPTl9USU1FX1BSRUNJU0lPTj0wCiAgdHlwZXNldCAtZyBQT1dFUkxF
VkVMOUtfQ09NTUFORF9FWEVDVVRJT05fVElNRV9GT1JFR1JPVU5EPTI0OAogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX0NPTU1BTkRfRVhFQ1VUSU9OX1RJTUVfRk9STUFUPSdkIGggbSBzJwogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0NPTU1BTkRfRVhFQ1VUSU9OX1RJTUVfVklTVUFMX0lERU5U
SUZJRVJfRVhQQU5TSU9OPQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0JBQ0tHUk9VTkRfSk9C
U19WRVJCT1NFPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQkFDS0dST1VORF9KT0JT
X0ZPUkVHUk9VTkQ9MzcKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ESVJFTlZfRk9SRUdST1VO
RD0xNzgKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BU0RGX0ZPUkVHUk9VTkQ9NjYKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19BU0RGX1NPVVJDRVM9KHNoZWxsIGxvY2FsIGdsb2JhbCkKICB0
eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BU0RGX1BST01QVF9BTFdBWVNfU0hPVz1mYWxzZQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0FTREZfU0hPV19TWVNURU09dHJ1ZQogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX0FTREZfU0hPV19PTl9VUEdMT0I9CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVM
OUtfQVNERl9SVUJZX0ZPUkVHUk9VTkQ9MTY4CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQVNE
Rl9QWVRIT05fRk9SRUdST1VORD0zNwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0FTREZfR09M
QU5HX0ZPUkVHUk9VTkQ9MzcKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BU0RGX05PREVKU19G
T1JFR1JPVU5EPTcwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQVNERl9SVVNUX0ZPUkVHUk9V
TkQ9MzcKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BU0RGX0RPVE5FVF9DT1JFX0ZPUkVHUk9V
TkQ9MTM0CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQVNERl9GTFVUVEVSX0ZPUkVHUk9VTkQ9
MzgKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BU0RGX0xVQV9GT1JFR1JPVU5EPTMyCiAgdHlw
ZXNldCAtZyBQT1dFUkxFVkVMOUtfQVNERl9KQVZBX0ZPUkVHUk9VTkQ9MzIKICB0eXBlc2V0IC1n
IFBPV0VSTEVWRUw5S19BU0RGX1BFUkxfRk9SRUdST1VORD02NwogIHR5cGVzZXQgLWcgUE9XRVJM
RVZFTDlLX0FTREZfRVJMQU5HX0ZPUkVHUk9VTkQ9MTI1CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVM
OUtfQVNERl9FTElYSVJfRk9SRUdST1VORD0xMjkKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19B
U0RGX1BPU1RHUkVTX0ZPUkVHUk9VTkQ9MzEKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BU0RG
X1BIUF9GT1JFR1JPVU5EPTk5CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQVNERl9IQVNLRUxM
X0ZPUkVHUk9VTkQ9MTcyCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQVNERl9KVUxJQV9GT1JF
R1JPVU5EPTcwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTk9SRFZQTl9GT1JFR1JPVU5EPTM5
CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTk9SRFZQTl97RElTQ09OTkVDVEVELENPTk5FQ1RJ
TkcsRElTQ09OTkVDVElOR31fQ09OVEVOVF9FWFBBTlNJT049CiAgdHlwZXNldCAtZyBQT1dFUkxF
VkVMOUtfTk9SRFZQTl97RElTQ09OTkVDVEVELENPTk5FQ1RJTkcsRElTQ09OTkVDVElOR31fVklT
VUFMX0lERU5USUZJRVJfRVhQQU5TSU9OPQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1JBTkdF
Ul9GT1JFR1JPVU5EPTE3OAogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX05OTl9GT1JFR1JPVU5E
PTcyCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVklNX1NIRUxMX0ZPUkVHUk9VTkQ9MzQKICB0
eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19NSUROSUdIVF9DT01NQU5ERVJfRk9SRUdST1VORD0xNzgK
ICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19OSVhfU0hFTExfRk9SRUdST1VORD03NAogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX0RJU0tfVVNBR0VfTk9STUFMX0ZPUkVHUk9VTkQ9MzUKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19ESVNLX1VTQUdFX1dBUk5JTkdfRk9SRUdST1VORD0yMjAKICB0
eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ESVNLX1VTQUdFX0NSSVRJQ0FMX0ZPUkVHUk9VTkQ9MTYw
CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfRElTS19VU0FHRV9XQVJOSU5HX0xFVkVMPTkwCiAg
dHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfRElTS19VU0FHRV9DUklUSUNBTF9MRVZFTD05NQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0RJU0tfVVNBR0VfT05MWV9XQVJOSU5HPWZhbHNlCiAgdHlw
ZXNldCAtZyBQT1dFUkxFVkVMOUtfVklfQ09NTUFORF9NT0RFX1NUUklORz1OT1JNQUwKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19WSV9NT0RFX05PUk1BTF9GT1JFR1JPVU5EPTEwNgogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX1ZJX1ZJU1VBTF9NT0RFX1NUUklORz1WSVNVQUwKICB0eXBlc2V0
IC1nIFBPV0VSTEVWRUw5S19WSV9NT0RFX1ZJU1VBTF9GT1JFR1JPVU5EPTY4CiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfVklfT1ZFUldSSVRFX01PREVfU1RSSU5HPU9WRVJUWVBFCiAgdHlwZXNl
dCAtZyBQT1dFUkxFVkVMOUtfVklfTU9ERV9PVkVSV1JJVEVfRk9SRUdST1VORD0xNzIKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19WSV9JTlNFUlRfTU9ERV9TVFJJTkc9CiAgdHlwZXNldCAtZyBQ
T1dFUkxFVkVMOUtfVklfTU9ERV9JTlNFUlRfRk9SRUdST1VORD02NgogIHR5cGVzZXQgLWcgUE9X
RVJMRVZFTDlLX1JBTV9GT1JFR1JPVU5EPTY2CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfU1dB
UF9GT1JFR1JPVU5EPTk2CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTE9BRF9XSElDSD01CiAg
dHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTE9BRF9OT1JNQUxfRk9SRUdST1VORD02NgogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX0xPQURfV0FSTklOR19GT1JFR1JPVU5EPTE3OAogIHR5cGVzZXQg
LWcgUE9XRVJMRVZFTDlLX0xPQURfQ1JJVElDQUxfRk9SRUdST1VORD0xNjYKICB0eXBlc2V0IC1n
IFBPV0VSTEVWRUw5S19UT0RPX0ZPUkVHUk9VTkQ9MTEwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVM
OUtfVE9ET19ISURFX1pFUk9fVE9UQUw9dHJ1ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1RP
RE9fSElERV9aRVJPX0ZJTFRFUkVEPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVElN
RVdBUlJJT1JfRk9SRUdST1VORD0xMTAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19USU1FV0FS
UklPUl9DT05URU5UX0VYUEFOU0lPTj0nJHtQOUtfQ09OVEVOVDowOjI0fSR7JHtQOUtfQ09OVEVO
VDoyNH06Ky4ufScKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19UQVNLV0FSUklPUl9GT1JFR1JP
VU5EPTc0CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQ09OVEVYVF9ST09UX0ZPUkVHUk9VTkQ9
MTc4CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQ09OVEVYVF97UkVNT1RFLFJFTU9URV9TVURP
fV9GT1JFR1JPVU5EPTE4MAogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0NPTlRFWFRfRk9SRUdS
T1VORD0xODAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19DT05URVhUX1JPT1RfVEVNUExBVEU9
JyVCJW5AJW0nCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQ09OVEVYVF97UkVNT1RFLFJFTU9U
RV9TVURPfV9URU1QTEFURT0nJW5AJW0nCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQ09OVEVY
VF9URU1QTEFURT0nJW5AJW0nCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQ09OVEVYVF97REVG
QVVMVCxTVURPfV97Q09OVEVOVCxWSVNVQUxfSURFTlRJRklFUn1fRVhQQU5TSU9OPQogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX1ZJUlRVQUxFTlZfRk9SRUdST1VORD0zNwogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX1ZJUlRVQUxFTlZfU0hPV19QWVRIT05fVkVSU0lPTj1mYWxzZQogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX1ZJUlRVQUxFTlZfU0hPV19XSVRIX1BZRU5WPWZhbHNlCiAgdHlw
ZXNldCAtZyBQT1dFUkxFVkVMOUtfVklSVFVBTEVOVl97TEVGVCxSSUdIVH1fREVMSU1JVEVSPQog
IHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0FOQUNPTkRBX0ZPUkVHUk9VTkQ9MzcKICB0eXBlc2V0
IC1nIFBPV0VSTEVWRUw5S19BTkFDT05EQV9DT05URU5UX0VYUEFOU0lPTj0nJHskeyR7JHtDT05E
QV9QUk9NUFRfTU9ESUZJRVIjXCh9JSB9JVwpfTotJHtDT05EQV9QUkVGSVg6dH19JwogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX1BZRU5WX0ZPUkVHUk9VTkQ9MzcKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19QWUVOVl9TT1VSQ0VTPShzaGVsbCBsb2NhbCBnbG9iYWwpCiAgdHlwZXNldCAtZyBQ
T1dFUkxFVkVMOUtfUFlFTlZfUFJPTVBUX0FMV0FZU19TSE9XPWZhbHNlCiAgdHlwZXNldCAtZyBQ
T1dFUkxFVkVMOUtfUFlFTlZfU0hPV19TWVNURU09dHJ1ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX1BZRU5WX0NPTlRFTlRfRVhQQU5TSU9OPScke1A5S19DT05URU5UfSR7JHtQOUtfUFlFTlZf
UFlUSE9OX1ZFUlNJT046IyRQOUtfQ09OVEVOVH06KyAkUDlLX1BZRU5WX1BZVEhPTl9WRVJTSU9O
fScKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19HT0VOVl9GT1JFR1JPVU5EPTM3CiAgdHlwZXNl
dCAtZyBQT1dFUkxFVkVMOUtfR09FTlZfU09VUkNFUz0oc2hlbGwgbG9jYWwgZ2xvYmFsKQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0dPRU5WX1BST01QVF9BTFdBWVNfU0hPVz1mYWxzZQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0dPRU5WX1NIT1dfU1lTVEVNPXRydWUKICB0eXBlc2V0IC1n
IFBPV0VSTEVWRUw5S19OT0RFTlZfRk9SRUdST1VORD03MAogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX05PREVOVl9TT1VSQ0VTPShzaGVsbCBsb2NhbCBnbG9iYWwpCiAgdHlwZXNldCAtZyBQT1dF
UkxFVkVMOUtfTk9ERU5WX1BST01QVF9BTFdBWVNfU0hPVz1mYWxzZQogIHR5cGVzZXQgLWcgUE9X
RVJMRVZFTDlLX05PREVOVl9TSE9XX1NZU1RFTT10cnVlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVM
OUtfTlZNX0ZPUkVHUk9VTkQ9NzAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19OT0RFRU5WX0ZP
UkVHUk9VTkQ9NzAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19OT0RFRU5WX1NIT1dfTk9ERV9W
RVJTSU9OPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTk9ERUVOVl97TEVGVCxSSUdI
VH1fREVMSU1JVEVSPQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX05PREVfVkVSU0lPTl9GT1JF
R1JPVU5EPTcwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfTk9ERV9WRVJTSU9OX1BST0pFQ1Rf
T05MWT10cnVlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfR09fVkVSU0lPTl9GT1JFR1JPVU5E
PTM3CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfR09fVkVSU0lPTl9QUk9KRUNUX09OTFk9dHJ1
ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1JVU1RfVkVSU0lPTl9GT1JFR1JPVU5EPTM3CiAg
dHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUlVTVF9WRVJTSU9OX1BST0pFQ1RfT05MWT10cnVlCiAg
dHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfRE9UTkVUX1ZFUlNJT05fRk9SRUdST1VORD0xMzQKICB0
eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19ET1RORVRfVkVSU0lPTl9QUk9KRUNUX09OTFk9dHJ1ZQog
IHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1BIUF9WRVJTSU9OX0ZPUkVHUk9VTkQ9OTkKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19QSFBfVkVSU0lPTl9QUk9KRUNUX09OTFk9dHJ1ZQogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX0xBUkFWRUxfVkVSU0lPTl9GT1JFR1JPVU5EPTE2MQogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX0pBVkFfVkVSU0lPTl9GT1JFR1JPVU5EPTMyCiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfSkFWQV9WRVJTSU9OX1BST0pFQ1RfT05MWT10cnVlCiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfSkFWQV9WRVJTSU9OX0ZVTEw9ZmFsc2UKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19QQUNLQUdFX0ZPUkVHUk9VTkQ9MTE3CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtf
UkJFTlZfRk9SRUdST1VORD0xNjgKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19SQkVOVl9TT1VS
Q0VTPShzaGVsbCBsb2NhbCBnbG9iYWwpCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUkJFTlZf
UFJPTVBUX0FMV0FZU19TSE9XPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUkJFTlZf
U0hPV19TWVNURU09dHJ1ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1JWTV9GT1JFR1JPVU5E
PTE2OAogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1JWTV9TSE9XX0dFTVNFVD1mYWxzZQogIHR5
cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1JWTV9TSE9XX1BSRUZJWD1mYWxzZQogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX0ZWTV9GT1JFR1JPVU5EPTM4CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtf
TFVBRU5WX0ZPUkVHUk9VTkQ9MzIKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19MVUFFTlZfU09V
UkNFUz0oc2hlbGwgbG9jYWwgZ2xvYmFsKQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0xVQUVO
Vl9QUk9NUFRfQUxXQVlTX1NIT1c9ZmFsc2UKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19MVUFF
TlZfU0hPV19TWVNURU09dHJ1ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0pFTlZfRk9SRUdS
T1VORD0zMgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0pFTlZfU09VUkNFUz0oc2hlbGwgbG9j
YWwgZ2xvYmFsKQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0pFTlZfUFJPTVBUX0FMV0FZU19T
SE9XPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfSkVOVl9TSE9XX1NZU1RFTT10cnVl
CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfUExFTlZfRk9SRUdST1VORD02NwogIHR5cGVzZXQg
LWcgUE9XRVJMRVZFTDlLX1BMRU5WX1NPVVJDRVM9KHNoZWxsIGxvY2FsIGdsb2JhbCkKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19QTEVOVl9QUk9NUFRfQUxXQVlTX1NIT1c9ZmFsc2UKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19QTEVOVl9TSE9XX1NZU1RFTT10cnVlCiAgdHlwZXNldCAtZyBQ
T1dFUkxFVkVMOUtfUEhQRU5WX0ZPUkVHUk9VTkQ9OTkKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19QSFBFTlZfU09VUkNFUz0oc2hlbGwgbG9jYWwgZ2xvYmFsKQogIHR5cGVzZXQgLWcgUE9XRVJM
RVZFTDlLX1BIUEVOVl9QUk9NUFRfQUxXQVlTX1NIT1c9ZmFsc2UKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19QSFBFTlZfU0hPV19TWVNURU09dHJ1ZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlL
X1NDQUxBRU5WX0ZPUkVHUk9VTkQ9MTYwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfU0NBTEFF
TlZfU09VUkNFUz0oc2hlbGwgbG9jYWwgZ2xvYmFsKQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlL
X1NDQUxBRU5WX1BST01QVF9BTFdBWVNfU0hPVz1mYWxzZQogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX1NDQUxBRU5WX1NIT1dfU1lTVEVNPXRydWUKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19I
QVNLRUxMX1NUQUNLX0ZPUkVHUk9VTkQ9MTcyCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfSEFT
S0VMTF9TVEFDS19TT1VSQ0VTPShzaGVsbCBsb2NhbCkKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19IQVNLRUxMX1NUQUNLX0FMV0FZU19TSE9XPXRydWUKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19URVJSQUZPUk1fU0hPV19ERUZBVUxUPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtf
VEVSUkFGT1JNX0NMQVNTRVM9KAogICAgICAnKicgICAgICAgICBPVEhFUikKICB0eXBlc2V0IC1n
IFBPV0VSTEVWRUw5S19URVJSQUZPUk1fT1RIRVJfRk9SRUdST1VORD0zOAogIHR5cGVzZXQgLWcg
UE9XRVJMRVZFTDlLX0tVQkVDT05URVhUX1NIT1dfT05fQ09NTUFORD0na3ViZWN0bHxoZWxtfGt1
YmVuc3xrdWJlY3R4fG9jfGlzdGlvY3RsfGtvZ2l0b3xrOXN8aGVsbWZpbGUnCiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfS1VCRUNPTlRFWFRfQ0xBU1NFUz0oCiAgICAgICcqJyAgICAgICBERUZB
VUxUKQogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0tVQkVDT05URVhUX0RFRkFVTFRfRk9SRUdS
T1VORD0xMzQKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19LVUJFQ09OVEVYVF9ERUZBVUxUX0NP
TlRFTlRfRVhQQU5TSU9OPQogIFBPV0VSTEVWRUw5S19LVUJFQ09OVEVYVF9ERUZBVUxUX0NPTlRF
TlRfRVhQQU5TSU9OKz0nJHtQOUtfS1VCRUNPTlRFWFRfQ0xPVURfQ0xVU1RFUjotJHtQOUtfS1VC
RUNPTlRFWFRfTkFNRX19JwogIFBPV0VSTEVWRUw5S19LVUJFQ09OVEVYVF9ERUZBVUxUX0NPTlRF
TlRfRVhQQU5TSU9OKz0nJHskezotLyRQOUtfS1VCRUNPTlRFWFRfTkFNRVNQQUNFfTojL2RlZmF1
bHR9JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0FXU19TSE9XX09OX0NPTU1BTkQ9J2F3c3xh
d2xlc3N8dGVycmFmb3JtfHB1bHVtaXx0ZXJyYWdydW50JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX0FXU19DTEFTU0VTPSgKICAgICAgJyonICAgICAgIERFRkFVTFQpCiAgdHlwZXNldCAtZyBQ
T1dFUkxFVkVMOUtfQVdTX0RFRkFVTFRfRk9SRUdST1VORD0yMDgKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19BV1NfRUJfRU5WX0ZPUkVHUk9VTkQ9NzAKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5
S19BWlVSRV9TSE9XX09OX0NPTU1BTkQ9J2F6fHRlcnJhZm9ybXxwdWx1bWl8dGVycmFncnVudCcK
ICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19BWlVSRV9GT1JFR1JPVU5EPTMyCiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfR0NMT1VEX1NIT1dfT05fQ09NTUFORD0nZ2Nsb3VkfGdjcycKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19HQ0xPVURfRk9SRUdST1VORD0zMgogIHR5cGVzZXQgLWcgUE9X
RVJMRVZFTDlLX0dDTE9VRF9QQVJUSUFMX0NPTlRFTlRfRVhQQU5TSU9OPScke1A5S19HQ0xPVURf
UFJPSkVDVF9JRC8vXCUvJSV9JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0dDTE9VRF9DT01Q
TEVURV9DT05URU5UX0VYUEFOU0lPTj0nJHtQOUtfR0NMT1VEX1BST0pFQ1RfTkFNRS8vXCUvJSV9
JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0dDTE9VRF9SRUZSRVNIX1BST0pFQ1RfTkFNRV9T
RUNPTkRTPTYwCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfR09PR0xFX0FQUF9DUkVEX1NIT1df
T05fQ09NTUFORD0ndGVycmFmb3JtfHB1bHVtaXx0ZXJyYWdydW50JwogIHR5cGVzZXQgLWcgUE9X
RVJMRVZFTDlLX0dPT0dMRV9BUFBfQ1JFRF9DTEFTU0VTPSgKICAgICAgJyonICAgICAgICAgICAg
IERFRkFVTFQpCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfR09PR0xFX0FQUF9DUkVEX0RFRkFV
TFRfRk9SRUdST1VORD0zMgogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0dPT0dMRV9BUFBfQ1JF
RF9ERUZBVUxUX0NPTlRFTlRfRVhQQU5TSU9OPScke1A5S19HT09HTEVfQVBQX0NSRURfUFJPSkVD
VF9JRC8vXCUvJSV9JwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1BVQkxJQ19JUF9GT1JFR1JP
VU5EPTk0CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVlBOX0lQX0ZPUkVHUk9VTkQ9ODEKICB0
eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19WUE5fSVBfQ09OVEVOVF9FWFBBTlNJT049CiAgdHlwZXNl
dCAtZyBQT1dFUkxFVkVMOUtfVlBOX0lQX0lOVEVSRkFDRT0nKGdwZHx3Z3woLip0dW4pKVswLTld
KicKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19WUE5fSVBfU0hPV19BTEw9ZmFsc2UKICB0eXBl
c2V0IC1nIFBPV0VSTEVWRUw5S19JUF9GT1JFR1JPVU5EPTM4CiAgdHlwZXNldCAtZyBQT1dFUkxF
VkVMOUtfSVBfQ09OVEVOVF9FWFBBTlNJT049JyR7UDlLX0lQX1JYX1JBVEU6KyU3MEY8JFA5S19J
UF9SWF9SQVRFIH0ke1A5S19JUF9UWF9SQVRFOislMjE1Rj4kUDlLX0lQX1RYX1JBVEUgfSUzOEYk
UDlLX0lQX0lQJwogIHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX0lQX0lOVEVSRkFDRT0nZS4qJwog
IHR5cGVzZXQgLWcgUE9XRVJMRVZFTDlLX1BST1hZX0ZPUkVHUk9VTkQ9NjgKICB0eXBlc2V0IC1n
IFBPV0VSTEVWRUw5S19CQVRURVJZX0xPV19USFJFU0hPTEQ9MjAKICB0eXBlc2V0IC1nIFBPV0VS
TEVWRUw5S19CQVRURVJZX0xPV19GT1JFR1JPVU5EPTE2MAogIHR5cGVzZXQgLWcgUE9XRVJMRVZF
TDlLX0JBVFRFUllfe0NIQVJHSU5HLENIQVJHRUR9X0ZPUkVHUk9VTkQ9NzAKICB0eXBlc2V0IC1n
IFBPV0VSTEVWRUw5S19CQVRURVJZX0RJU0NPTk5FQ1RFRF9GT1JFR1JPVU5EPTE3OAogIHR5cGVz
ZXQgLWcgUE9XRVJMRVZFTDlLX0JBVFRFUllfU1RBR0VTPSgnYmF0dGVyeScpCiAgdHlwZXNldCAt
ZyBQT1dFUkxFVkVMOUtfQkFUVEVSWV9WRVJCT1NFPWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxF
VkVMOUtfV0lGSV9GT1JFR1JPVU5EPTY4CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVElNRV9G
T1JFR1JPVU5EPTY2CiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVElNRV9GT1JNQVQ9JyVEeyVI
OiVNOiVTfScKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19USU1FX1VQREFURV9PTl9DT01NQU5E
PWZhbHNlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfVElNRV9WSVNVQUxfSURFTlRJRklFUl9F
WFBBTlNJT049CiAgZnVuY3Rpb24gcHJvbXB0X2V4YW1wbGUoKSB7CiAgICBwMTBrIHNlZ21lbnQg
LWYgMjA4IC1pICcqJyAtdCAnaGVsbG8sICVuJwogIH0KICBmdW5jdGlvbiBpbnN0YW50X3Byb21w
dF9leGFtcGxlKCkgewogICAgcHJvbXB0X2V4YW1wbGUKICB9CiAgdHlwZXNldCAtZyBQT1dFUkxF
VkVMOUtfVFJBTlNJRU5UX1BST01QVD1hbHdheXMKICB0eXBlc2V0IC1nIFBPV0VSTEVWRUw5S19J
TlNUQU5UX1BST01QVD12ZXJib3NlCiAgdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfRElTQUJMRV9I
T1RfUkVMT0FEPXRydWUKICAoKCAhICQrZnVuY3Rpb25zW3AxMGtdICkpIHx8IHAxMGsgcmVsb2Fk
Cn0KdHlwZXNldCAtZyBQT1dFUkxFVkVMOUtfQ09ORklHX0ZJTEU9JHskeyglKTotJXh9OmF9Cigo
ICR7I3AxMGtfY29uZmlnX29wdHN9ICkpICYmIHNldG9wdCAke3AxMGtfY29uZmlnX29wdHNbQF19
CididWlsdGluJyAndW5zZXQnICdwMTBrX2NvbmZpZ19vcHRzJwo=
EOF

ln -s /etc/zsh/zshrc /etc/zshrc
chsh -s $(which zsh) $(whoami)
