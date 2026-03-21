#!/usr/bin/env bash
set -e

MYPATH=$(readlink -e "$0")
MYDIR=$(dirname "$MYPATH")

IMG_HOST=localhost
IMG_PORT=
IMG_NAMESPACE=example
IMG_REPOSITORY=po26-1
IMG_TAG=

IMG_REF="${IMG_HOST:+$IMG_HOST${IMG_PORT:+:$IMG_PORT}/}$IMG_NAMESPACE/$IMG_REPOSITORY${IMG_TAG:+:$IMG_TAG}"

echo "$IMG_REF"

docker build --tag "$IMG_REF" "$MYDIR"
docker run "$IMG_REF"
