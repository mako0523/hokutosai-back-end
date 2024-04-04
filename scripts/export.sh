#!/bin/bash

source "./.env"

mkdir -p "${OUTPUT_DIR}"

curl --show-error --silent -u "${BASIC_AUTHENTICATION_USER}:${BASIC_AUTHENTICATION_PASSWORD}" "https://hokutofes.com/api/vote" |
    jq >"${OUTPUT_DIR}/vote.json"
