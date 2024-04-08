#!/bin/bash

source "./.env"

DOWNLOAD_DIR=${1:-out}

mkdir -p "${DOWNLOAD_DIR}"

curl --show-error --silent -u "${BASIC_AUTHENTICATION_USER}:${BASIC_AUTHENTICATION_PASSWORD}" "https://hokutofes.com/api/vote" |
    jq >"${DOWNLOAD_DIR}/vote.json"
