#!/usr/bin/env bash

cd "$(dirname "$(readlink -e "$0")")"

#export APP_ENV=prod

#workaround for doctrine's bullshit
export DB_FILE=$(bin/console debug:config --resolve-env doctrine | grep url: | sed s,^.*sqlite://,, | tr -d "'")

if ! [[ -e "$DB_FILE" ]]; then
	sqlite3 "$DB_FILE" ""
	php bin/console doctrine:schema:update --force
fi

exec bash
