#!/usr/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit

export TERM

case "$TERM" in
	xterm-color|*-256color) spring_colors=ALWAYS; gradle_colors=colored;;
	*) spring_colors=DETECT; gradle_colors=plain;;
esac

./gradlew bootRun --console="$gradle_colors" --args=--spring.output.ansi.enabled="$spring_colors"
bash
