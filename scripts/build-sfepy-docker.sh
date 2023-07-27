#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m'

function usage {
    echo -e "Usage: $0 [-v version_tag] [-r repository] [-d build_dirs] [-p] [-s] \n"
    exit 1
}

REPO="sfepy"
VERSION=""

PUSH="NO"

SYNC="NO"
README="README.md"
SYNC_TOKEN_FILE=".app-access-token-dockerhub"
BUILD_DIRS="sfepy-desktop"

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
   -s|--sync-readme)
    SYNC="YES"
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

SCRIPT_BIN="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$SCRIPT_BIN"/.. || exit

for dir in ${BUILD_DIRS}
do
  cd "${dir}" || exit

  if [[ "$PUSH" = "YES" ]]; then
    echo -e "${RED}Pushing Docker images to $REPO repository${NC}"
    docker push "$REPO/${dir}"
    docker push "$REPO/${dir}:$VERSION"
    echo -e "Done.\n"
    exit 0
  fi

  if [[ "$SYNC" = "YES" ]]; then
    echo -e "${RED}Syncing ${dir}/${README} to Docker description file...${NC}"
    "${SCRIPT_BIN}"/docker-sync-readme.py \
        --username="kejzlar" \
        --readme="${README}" \
        --repo="$REPO/${dir}" \
        --password="$(<"${SCRIPT_BIN}"/${SYNC_TOKEN_FILE})"
    echo -e "Done.\n"
    exit 0
  fi

  echo -e "${RED}Building Docker image(s): ${dir}:${VERSION}${NC}"
  docker build --rm .  --build-arg SFEPY_RELEASE="${VERSION}" \
         -t "$REPO/${dir}" -t "$REPO/${dir}:$VERSION"
  echo -e "Done.\n"

  cd ..
done
exit 0
