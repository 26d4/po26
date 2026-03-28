#!/usr/bin/env bash

set -e

announce() { local -; set -x; "$@"; }

echo "Create product"
RESPONSE=$(announce curl --header "Content-Type: application/json" --request POST --data '{"name":"xyz","price":2999}' http://localhost:8000/api/product)

if which jq; then
	ID=$(echo "$RESPONSE" | jq '.id')
else
	ID=$(echo "$RESPONSE" | grep -oP '"id":\d+?,' | grep -oP '\d+')
fi

echo "$RESPONSE    -->  id=$ID"

sleep 3

echo "Show product"
announce curl http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Edit product"
announce curl --header "Content-Type: application/json" --request PATCH --data '{"price":4950}' http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Show product again"
announce curl http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Replace product"
announce curl --header "Content-Type: application/json" --request PUT --data '{"name":"zyx"}' http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Show product list"
announce curl http://localhost:8000/api/product
echo
sleep 3

echo "Delete product"
announce curl --request DELETE http://localhost:8000/api/product/"$ID"
echo
sleep 3

echo "Show product list again"
announce curl http://localhost:8000/api/product
echo
