#!/usr/bin/env bash

set -e

announce() { local -; set -x; "$@"; }

jdiff() {
	diff <(jq --sort-keys . "$1") <(jq --sort-keys . "$2")
}

tc() {
	if jqdiff "$2" "$3"; then
		echo "$1 -- OK"
	else
		echo "$1 -- FAILED"
	fi
}

echo "Create product"
RESPONSE=$(announce curl --no-progress-meter --header "Content-Type: application/json" --request POST --data '{"name":"xyz","price":2999}' http://localhost:8000/api/product)

ID=$(echo "$RESPONSE" | jq '.id')

echo "$RESPONSE    -->  id=$ID"

sleep 3

tc "Show product" "$(announce curl --no-progress-meter http://localhost:8000/api/product/"$ID")" "{\"id\":$ID,\"name\":\"xyz\",\"price\":2999}"
echo
sleep 3

echo "Edit product"
announce curl --no-progress-meter --header "Content-Type: application/json" --request PATCH --data '{"price":4950}' http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Show product again"
announce curl http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Replace product"
announce curl --no-progress-meter --header "Content-Type: application/json" --request PUT --data '{"name":"zyx"}' http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Show product list"
announce curl --no-progress-meter http://localhost:8000/api/product
echo
sleep 3

echo "Delete product"
announce curl --no-progress-meter --request DELETE http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Show product list again"
announce curl --no-progress-meter http://localhost:8000/api/product
echo
