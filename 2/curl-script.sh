#!/usr/bin/env bash

set -e

curl() { command curl -f --no-progress-meter "$@"; }

announce() { >&2 echo "+> $@"; "$@"; }

jqdiff() {
	diff <(jq --sort-keys . <<< "$1") <(jq --sort-keys . <<< "$2")
}

ok() {
	if "${@:2}"; then
		echo "$1 -- OK"
	else
		echo "$1 -- FAILED"
		return 1
	fi
}

tc() {
	ok "$1" jqdiff "$2" "$3"
}

#tc_grep() {
#	
#}

echo "PRODUCT"

echo "Create product"
RESPONSE=$(announce curl --header "Content-Type: application/json" --request POST --data '{"name":"xyz","price":2999}' http://localhost:8000/api/product)

ID=$(echo "$RESPONSE" | jq '.id')

echo "$RESPONSE    -->  id=$ID"

sleep 1

tc "Show product" "$(announce curl http://localhost:8000/api/product/"$ID")" "{\"id\":$ID,\"name\":\"xyz\",\"price\":2999}"
echo
sleep 1

ok "Edit product" announce curl --header "Content-Type: application/json" --request PATCH --data '{"price":4950}' http://localhost:8000/api/product/"$ID"
echo
sleep 1

tc "Show product again" "$(announce curl http://localhost:8000/api/product/"$ID")" "{\"id\":$ID,\"name\":\"xyz\",\"price\":4950}"
echo
sleep 1

tc "Replace product (Bad put)" \
"$(announce curl --no-fail --header "Content-Type: application/json" --request PUT --data '{"name":"zyx"}' http://localhost:8000/api/product/"$ID")" \
'{"message": "Missing fields","missing_fields": ["price"]}'

echo
sleep 1

ok "Show product list" announce curl http://localhost:8000/api/product
echo
sleep 1

ok "Delete product" announce curl --request DELETE http://localhost:8000/api/product/"$ID"
echo
sleep 1

tc "Show product list again" "$(announce curl http://localhost:8000/api/product)" '[]'
echo
sleep 1

echo "USER"

echo "Create user"
RESPONSE=$(announce curl --header "Content-Type: application/json" --request POST --data '{"name":"xyz"}' http://localhost:8000/api/user)

ID=$(echo "$RESPONSE" | jq '.id')

echo "$RESPONSE    -->  id=$ID"

sleep 1

tc "Show user" "$(announce curl http://localhost:8000/api/user/"$ID")" "{\"id\":$ID,\"name\":\"xyz\"}"
echo
sleep 1

ok "Edit user" announce curl --header "Content-Type: application/json" --request PATCH --data '{"name": "zyx"}' http://localhost:8000/api/user/"$ID"
echo
sleep 1

tc "Show user again" "$(announce curl http://localhost:8000/api/user/"$ID")" "{\"id\":$ID,\"name\":\"zyx\"}"
echo
sleep 1

tc "Replace user" \
"$(announce curl --header "Content-Type: application/json" --request PUT --data '{"name":"xyz"}' http://localhost:8000/api/user/"$ID")" \
"{\"id\":$ID,\"name\":\"xyz\"}"

echo
sleep 1

ok "Show user list" announce curl http://localhost:8000/api/user
echo
sleep 1

echo "ARTICLE"

echo "Create article"
RESPONSE=$(announce curl --header "Content-Type: application/json" --request POST --data '{"author":'"$ID"',"content":"lorem ipsum"}' http://localhost:8000/api/article)

AID=$(echo "$RESPONSE" | jq '.id')

echo "$RESPONSE    -->  id=$AID"

sleep 1

tc "Show article" "$(announce curl http://localhost:8000/api/article/"$AID" | jq '{id,author,content}')" '{"id":'"$AID"',"author":{"id":'"$ID"',"name":"xyz"},"content":"lorem ipsum"}'
echo
sleep 1

ok "Edit article" announce curl --header "Content-Type: application/json" --request PATCH --data '{"content": "dolor"}' http://localhost:8000/api/article/"$AID"
echo
sleep 1

tc "Show article again" "$(announce curl http://localhost:8000/api/article/"$AID" | jq '{id,author,content}')" '{"id":'"$AID"',"author":{"id":'"$ID"',"name":"xyz"},"content":"dolor"}'
echo
sleep 1

#tc "Replace article" \
#"$(announce curl --header "Content-Type: application/json" --request PUT --data '{"name":"xyz"}' http://localhost:8000/api/article/"$AID")" \
#"{\"id\":$ID,\"name\":\"xyz\"}"
#echo
#sleep 1

ok "Show article list" announce curl http://localhost:8000/api/article
echo
sleep 1

ok "Delete article" announce curl --request DELETE http://localhost:8000/api/article/"$AID"
echo
sleep 1

tc "Show article list again" "$(announce curl http://localhost:8000/api/article)" '[]'
echo

ok "Delete user" announce curl --request DELETE http://localhost:8000/api/user/"$AID"
echo
sleep 1

tc "Show user list again" "$(announce curl http://localhost:8000/api/user)" '[]'
echo

