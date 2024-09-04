#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m'

function usage {
    echo -e "Usage: $0 [-v version_tag] [-r repository] [-d build_dirs] [-p] [-pt] [-s] \n"
    exit 1
}

REPO="sfepy"

TEST_REPO="kejzlar"
TEST_PREFIX=""

VERSION=""

PUSH="NO"
PUSH_FLAG="--load"

SYNC="NO"
README="README.md"
SYNC_TOKEN_FILE=".secrets/.app-access-token-dockerhub"

BUILD_DIRS="sfepy-desktop"
BUILD_PLATFORM="linux/amd64,linux/arm64"
BUILDER="sfepy-builder"

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
    PUSH_FLAG="--push"
    shift
    ;;
  -pt|-t|--push_test)
    PUSH="YES"
    PUSH_FLAG="--push"
    REPO="${TEST_REPO}"
    TEST_PREFIX="test-"
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

if ! docker buildx ls | grep -q "${BUILDER}" ; then
  echo -e "${RED}Warning: no expected multi-platform builder ($BUILDER) found. Creating new one...${NC}"
  docker buildx create --name "${BUILDER}" --driver docker-container --use --bootstrap
fi

SCRIPT_BIN="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$SCRIPT_BIN"/.. || exit

for dir in ${BUILD_DIRS}
do
  cd "${dir}" || exit

  if [[ "$SYNC" = "YES" ]]; then
    echo -e "${RED}Syncing ${dir}/${README} to Docker description file...${NC}"
    "${SCRIPT_BIN}"/docker-sync-readme.py \
        --username="kejzlar" \
        --readme="${README}" \
        --repo="$REPO/${dir}" \
        --password="$(<"${SCRIPT_BIN}"/${SYNC_TOKEN_FILE})"

    continue
  fi

  echo -e "${RED}Building Docker image(s): ${TEST_PREFIX}${dir}:${VERSION}${NC}"
  echo -e "${RED}Multiplatform build enabled. Supported platforms: ${BUILD_PLATFORM}${NC}"

  if [[ "$PUSH" = "YES" ]]; then
    echo -e "${RED}Pushing Docker images requested. Pushing to repository: $REPO ${NC}"
  fi

  docker buildx build "${PUSH_FLAG}" --platform "${BUILD_PLATFORM}" --rm --build-arg SFEPY_RELEASE="${VERSION}" \
         --tag "$REPO/${TEST_PREFIX}${dir}" --tag "$REPO/${TEST_PREFIX}${dir}:${VERSION}" .

  cd ..
done
exit 0
