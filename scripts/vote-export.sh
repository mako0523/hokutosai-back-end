#!/bin/bash

source "./.env"

echo "${OUTPUT_DIR}"

if [ ! -d "${OUTPUT_DIR}" ]; then
    mkdir "${OUTPUT_DIR}"
fi

curl "https://hokutofes.com/api/vote" | jq >"${OUTPUT_DIR}/vote.json"
