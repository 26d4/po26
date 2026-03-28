#!/usr/bin/env bash

cd "$(dirname "$(readlink -e "$0")")"

#export APP_ENV=prod

#workaround for doctrine's bullshit
export DB_FILE=$(bin/console debug:config --resolve-env doctrine | grep url: | sed s,^.*sqlite://,, | tr -d "'")

if ! [[ -e "$DB_FILE" ]]; then
	sqlite3 "$DB_FILE" ""
	php bin/console doctrine:schema:update --force
else
	if [[ -n "$(php bin/console make:migration -q)" ]]; then
		php bin/console doctrine:migrations:migrate
	fi
fi

exec bash
