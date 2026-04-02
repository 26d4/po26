#!/usr/bin/env bash

cd "$(dirname "$(readlink -e "$0")")"

source .env
source .env.local
source .env."$APP_ENV"
source .env."$APP_ENV".local

echo "APP ENV = $APP_ENV"

#workaround for doctrine's bullshit
export DB_FILE=$(bin/console debug:config --resolve-env doctrine | grep url: | sed s,^.*sqlite://,, | tr -d "'")

if ! [[ -e "$DB_FILE" ]] || [[ "$APP_ENV" = test ]]; then
	if [[ "$APP_ENV" = test ]]; then rm "$DB_FILE"; fi
	sqlite3 "$DB_FILE" ""
	php bin/console doctrine:schema:update --force
#else
#	if [[ -n "$(php bin/console make:migration -q)" ]]; then
#		php bin/console doctrine:migrations:migrate
#	fi
fi

symfony serve
bash
