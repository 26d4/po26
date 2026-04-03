#!/usr/bin/env bash
set -e

MYPATH=$(readlink -e "$0")
MYDIR=$(dirname "$MYPATH")

IMG_HOST=localhost
IMG_PORT=
IMG_NAMESPACE=example
IMG_REPOSITORY=po26-3
IMG_TAG=

IMG_REF="${IMG_HOST:+$IMG_HOST${IMG_PORT:+:$IMG_PORT}/}$IMG_NAMESPACE/$IMG_REPOSITORY${IMG_TAG:+:$IMG_TAG}"

echo "$IMG_REF"

while (( $# > 0 )); do
	case "$1" in
		clean) [ -z "$(docker image ls -q "$IMG_REF")" ] || docker image rm --force "$IMG_REF";;
		build) docker build --tag "$IMG_REF" "$MYDIR";;
		run) [ -z "$(docker image ls -q "$IMG_REF")" ] || docker run -it --network host -v "$MYDIR":/home/ubuntu/app:rw -v "$IMG_REPOSITORY"-gradle:/home/ubuntu/.gradle "$IMG_REF";; 
	esac
	shift
done
