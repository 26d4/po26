#!/usr/bin/env bash
set -e

MYPATH=$(readlink -e "$0")
MYDIR=$(dirname "$MYPATH")

IMG_HOST=localhost
IMG_PORT=
IMG_NAMESPACE=example
IMG_REPOSITORY=po26-2
IMG_TAG=

IMG_REF="${IMG_HOST:+$IMG_HOST${IMG_PORT:+:$IMG_PORT}/}$IMG_NAMESPACE/$IMG_REPOSITORY${IMG_TAG:+:$IMG_TAG}"

echo "$IMG_REF"

if [ "$1" == "build" ]; then
	docker build --tag "$IMG_REF" "$MYDIR"
fi
docker run -it --network host -v "$IMG_REPOSITORY"-var:/home/defaultuser/php/var "$IMG_REF"
