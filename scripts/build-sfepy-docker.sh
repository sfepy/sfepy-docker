#!/usr/bin/env bash

function usage {
    echo -e "Usage: $0 -v version_tag [-r repository] \n"
    exit 1
}

REPO="kejzlar"
VERSION=""

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -v|--version_tag)
    VERSION="$2"
    shift
    shift
    ;;
  -r|--repository)
    REPO="$2"
    shift
    shift
    ;;
  *)
    usage
    exit 1
    shift
    ;;
esac
done

if [[ -z $VERSION ]]; then
  VERSION=$(git ls-remote --tags --sort="v:refname" \
          https://github.com/sfepy/sfepy.git | \
          grep release | tail -n1  | \
          sed 's/.*\///; s/\^{}//; s/release_//')
fi

CWD="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$CWD"/..

pushd notebook || exit
docker build .  -t "$REPO/sfepy-notebook" \
                -t "$REPO/sfepy-notebook:$VERSION"
popd || exit

exit 0