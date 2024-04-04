#!/bin/bash

source "./.env"

curl --show-error --silent -u "${BASIC_AUTHENTICATION_USER}:${BASIC_AUTHENTICATION_PASSWORD}" "https://hokutofes.com/api/vote" |
    jq --color-output | less --RAW-CONTROL-CHARS
