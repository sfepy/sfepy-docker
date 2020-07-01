#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m'

function usage {
    echo -e "Usage: $0 [-v version_tag] [-r repository] [-d build_dirs] [-p] \n"
    exit 1
}

REPO="sfepy"
VERSION=""
PUSH="NO"
BUILD_DIRS="sfepy-notebook sfepy-x11vnc-desktop"

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
  -d|--build_dirs)
    BUILD_DIRS="$2"
    shift
    shift
    ;;
  -p|--push)
    PUSH="YES"
    shift
    ;;
  *)
    usage
    exit 1
    ;;
esac
done

if [[ -z "$VERSION" ]]; then
  VERSION=$(git ls-remote --tags --sort="v:refname" \
          https://github.com/sfepy/sfepy.git | \
          grep release | tail -n1  | \
          sed 's/.*\///; s/\^{}//; s/release_//')
fi

CWD="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$CWD"/.. || exit

for dir in ${BUILD_DIRS}
do
  cd "${dir}" || exit

  echo -e "${RED}Building Docker image(s): ${dir}:${VERSION}${NC}"
  docker build --rm .  --build-arg SFEPY_RELEASE="${VERSION}" \
         -t "$REPO/${dir}" -t "$REPO/${dir}:$VERSION"
  echo -e "Done.\n"

  if [[ "$PUSH" = "YES" ]]; then
    echo -e "${RED}Pushing Docker images to $REPO repository${NC}"
    docker push "$REPO/${dir}"
    docker push "$REPO/${dir}:$VERSION"
    echo -e "Done.\n"
  fi

  cd ..
done
exit 0
