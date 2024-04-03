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

usage_uplode_file() {
    cat >&2 <<END
Usage: uplode_file <FILE> [DIRECTORY]
END
}

uplode_file() {
    if [ -z "${1}" ]; then
        usage_uplode_file
        return 1
    fi

    local uplode_target_dir="ftp://${XSERVER_HOST_NAME}/hokutofes.com/script/${2}"
    curl -T "${1}" -u "${XSERVER_USER}:${XSERVER_PASSWORD}" --ftp-create-dirs "${uplode_target_dir}"
}

uplode_file "./.env"
uplode_file "./package.json"
uplode_file "./package-lock.json"
uplode_file "./src/vote.js" "src/"

usage_execute_command_in_server() {
    cat >&2 <<END
Usage: execute_command_in_server <command>
END
}

execute_command_in_server() {
    if [ -z "${1}" ]; then
        usage_execute_command_in_server
        return 1
    fi

    expect -c "
        spawn ssh xserver \"${1}\"
        expect passphrase
        send ${XSERVER_PASSPHRASE}\n
        expect $
    "
}

start_server="
    cd ~/hokutofes.com/script || exit
    npm ci --omit=dev
    npm run daemon-stop
    npm run daemon-start
"

execute_command_in_server "${start_server}"
