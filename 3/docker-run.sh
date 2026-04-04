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
IMG_REF_DEV="${IMG_REF%:*}:dev"

echo "$IMG_REF"

while (( $# > 0 )); do
	case "$1" in
		clean)
			[ -z "$(docker image ls -q "$IMG_REF")" ] || docker image rm --force "$IMG_REF"
			[ -z "$(docker image ls -q "$IMG_REF_DEV")" ] || docker image rm --force "$IMG_REF_DEV"
			;;
		build-dev) docker build -f Dockerfile-bind --tag "$IMG_REF_DEV" "$MYDIR";;
		build) docker build -f Dockerfile-contain --tag "$IMG_REF" "$MYDIR";;
		run-bind) [ -z "$(docker image ls -q "$IMG_REF_DEV")" ] || docker run -it --network host -e TERM="$TERM" -v "$MYDIR":/home/ubuntu/app:rw -v "$IMG_REPOSITORY"-gradle:/home/ubuntu/.gradle "$IMG_REF_DEV";;
		run) [ -z "$(docker image ls -q "$IMG_REF")" ] || docker run -it --network host -e TERM="$TERM" "$IMG_REF";; 
	esac
	shift
done
