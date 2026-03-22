#!/usr/bin/env bash

cd "$(dirname "$(readlink -e "$0")")"

#source ./.env
#source ./.env.local

#if ! [[ -e "$DB_FILE" ]]; then
#	sqlite3 "$DB_FILE" < populate.sql
#fi

exec bash
