#!/bin/bash
#
# gh-dl-release! It works!
#
# This script downloads an asset from latest or specific Github release of a
# private repo. Feel free to extract more of the variables into command line
# parameters.
#
# PREREQUISITES
#
# curl, wget, jq
#
# USAGE
#
# Set all the variables inside the script, make sure you chmod +x it, then
# to download specific version to my_app.tar.gz:
#
#     gh-dl-release 2.1.1 my_app.tar.gz
#
# to download latest version:
#
#     gh-dl-release latest latest.tar.gz
#
# If your version/tag doesn't match, the script will exit with error.
set -ex

VERSION=$1 # tag name or the word "latest"
REPO=$2
FILE=$3
GITHUB="https://api.github.com"
TOKEN=${TOKEN:?The Github access token needs to be set!}

alias errcho='>&2 echo'

function gh_curl() {
    curl -H "Authorization: token ${TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        "$@"
}

if [ "$VERSION" = "latest" ]; then
    # Github should return the latest release first.
    parser=".[0].assets | map(select(.name == \"$FILE\"))[0].id"
else
    parser=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$FILE\"))[0].id"
fi

asset_id=$(gh_curl -s "$GITHUB/repos/${REPO}/releases" | jq "$parser")
if [ "$asset_id" = "null" ]; then
    errcho "ERROR: version not found $VERSION"
    exit 1
fi

wget -q --header='Accept:application/octet-stream' --header="Authorization: token ${TOKEN}" \
  "https://api.github.com/repos/${REPO}/releases/assets/${asset_id}" \
  -O "${FILE}"

echo $?
