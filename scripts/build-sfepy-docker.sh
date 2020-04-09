#!/usr/bin/env bash

function usage {
    echo -e "Usage: $0 -v version_tag [-r repository] [-p] \n"
    exit 1
}

REPO="sfepy"
VERSION=""
PUSH=""

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

for dir in sfepy-notebook, sfepy-x11vnc-notebook
do
  cd ${dir} || exit

  echo -n "Building ${dir}:${VERSION} images..."
  docker build --rm .  --build-arg SFEPY_RELEASE="${VERSION}" \
         -t "$REPO/${dir}" -t "$REPO/${dir}:$VERSION"
  echo -e " done.\n"

  if [[ -n "$PUSH" ]]; then
    echo -n "Pushing images to $REPO repository..."
    docker push "$REPO/${dir}"
    docker push "$REPO/${dir}:$VERSION"
    echo " done."
  fi

  cd ..
done

exit 0