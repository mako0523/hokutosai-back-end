#!/bin/bash

source "./.env"

[ -z "${XSERVER_USER}" ] ||
    [ -z "${XSERVER_PASSWORD}" ] ||
    [ -z "${XSERVER_HOST_NAME}" ] ||
    [ -z "${XSERVER_PASSPHRASE}" ]
is_environment_variable_undefined="${?}"

if [ "${is_environment_variable_undefined}" -eq 0 ]; then
    cat >&2 <<END
$0: environment variable is undefined
END
    exit 1
fi

uplode_file() {
    local uplode_target_dir="ftp://${XSERVER_HOST_NAME}/hokutosai.net/script/${2}"
    curl --show-error --silent --ftp-create-dirs \
        -u "${XSERVER_USER}:${XSERVER_PASSWORD}" -T "${1}" "${uplode_target_dir}"
}

uplode_file "./.env"
uplode_file "./package.json"
uplode_file "./package-lock.json"
uplode_file "./src/vote.js" "src/"

execute_command_in_server() {
    expect -c "
        spawn -noecho ssh hokutofes \"${1}\"
        expect passphrase
        send ${XSERVER_PASSPHRASE}\n
        expect $
    "
}

start_server="
    cd ~/hokutosai.net/script || exit
    npm ci --omit=dev
    npm run --silent daemon-stop
    npm run --silent daemon-start
"

execute_command_in_server "${start_server}"
