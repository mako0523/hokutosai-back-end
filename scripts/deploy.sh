#!/bin/bash

source "./.env"

deploy() {
    deploy_target_dir="ftp://${XSERVER_HOST_NAME}/hokutofes.com/script/${2}"
    curl -T "${1}" -u "${XSERVER_USER}:${XSERVER_PASSWORD}" --ftp-create-dirs "${deploy_target_dir}"
}

deploy "./.env"
deploy "./package.json"
deploy "./package-lock.json"
deploy "./src/vote.js" "src/"

execute_command_in_server() {
    expect -c "
        spawn ssh xserver \"${1}\"
        expect passphrase
        send ${XSERVER_PASSPHRASE}\n
        expect $
    "
}

start_server="
    cd ~/hokutofes.com/script || exit
    npm ci
    npm run daemon-stop
    npm run daemon-start
"

execute_command_in_server "${start_server}"
