#!/usr/bin/env bash
# Copyright (c) 2023 José Manuel Barroso Galindo <theypsilon@gmail.com>

set -euo pipefail

download_jtcores() {
    local OUTPUT_FOLDER="$(cd ${1} ; pwd)"
    echo "OUTPUT_FOLDER=${OUTPUT_FOLDER}"

    # get list of cores from the wiki
    local CORE_URLS=$(curl -sSLf "https://github.com/jotego/jtbin/wiki"| awk '/Arcade-Cores-Top/,/Arcade-Cores-Bottom/' | grep -ioE "https://github.com/jotego/jtbin/tree/[a-zA-Z0-9./_-]*")

    local TMP_FOLDER="$(mktemp -d)"
    
    # checkout jtbin repository in tmp folder
    download_repository "${TMP_FOLDER}" "https://github.com/jotego/jtbin.git" "master"

    mkdir -p "${OUTPUT_FOLDER}/_Arcade/cores/"

    local IFS=$'\n'

    for folder in $(echo "${CORE_URLS[@]}" | sed -n -e 's%^.*tree/master/%%p') ; do

        for bin in $(files_with_no_date "${TMP_FOLDER}/${folder}/releases") ; do
            local LAST_RELEASE_FILE="${bin}"
            if is_not_rbf_release "${LAST_RELEASE_FILE}" ; then
                continue
            fi
            if [ ! -f "${TMP_FOLDER}/${folder}/releases/${LAST_RELEASE_FILE}" ] ; then
                echo "Not found ${TMP_FOLDER}/${folder}/releases/${LAST_RELEASE_FILE}"
                continue
            fi

            # for each core it copies the RBF file to _Arcade/cores/
            echo copy_file "${TMP_FOLDER}/${folder}/releases/${LAST_RELEASE_FILE}" "${OUTPUT_FOLDER}/_Arcade/cores/$(basename ${LAST_RELEASE_FILE})"
            copy_file "${TMP_FOLDER}/${folder}/releases/${LAST_RELEASE_FILE}" "${OUTPUT_FOLDER}/_Arcade/cores/$(basename ${LAST_RELEASE_FILE})"
        done
    done

    pushd ${TMP_FOLDER}

    # we copy each MRA not in _alternatives to _Arcade/
    #  * Assumption 1: all MRA files with the same name must be identical
    #  * Assumption 2: all MRA files must be compatible with MiSTer
    for mra in $(find mra -type f -iname '*.mra' -not -path "*/_alternatives/*") ; do
        echo copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
        copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
    done

    pushd mra

    # we copy each MRA in _alternatives to _Arcade/_alternatives keeping same tree folder structure
    #  * Assumption: all MRA alternatives must be compatible with MiSTer
    for alts in $(find _alternatives/ -type f -iname '*.mra') ; do
        echo copy_file "${alts}" "${OUTPUT_FOLDER}/_Arcade/${alts}"
        copy_file "${alts}" "${OUTPUT_FOLDER}/_Arcade/${alts}"
    done

    popd
    popd

    rm -rf "${TMP_FOLDER}"
}

download_repository() {
    local FOLDER="${1}"
    local GIT_URL="${2}"
    local BRANCH="${3}"
    pushd "${TMP_FOLDER}" > /dev/null 2>&1
    git init -q
    git remote add origin "${GIT_URL}"
    git -c protocol.version=2 fetch --depth=1 -q --no-tags --prune --no-recurse-submodules origin "${BRANCH}"
    git checkout -qf FETCH_HEAD
    popd > /dev/null 2>&1
}

copy_file() {
    local SOURCE="${1}"
    local TARGET="${2}"

    mkdir -p "${TARGET%/*}"
    cp -r "${SOURCE}" "${TARGET}"
}

is_not_rbf_release() {
    is_not_file_extension "${1}" "rbf"
}

is_not_file_extension() {
    local INPUT_FILE="${1}"
    local EXPECTED_EXTENSION="${2}"
    if is_file_extension "${INPUT_FILE}" "${EXPECTED_EXTENSION}" ; then
        return 1
    fi
    >&2 echo "${INPUT_FILE} is NOT a ${EXPECTED_EXTENSION^^} file."
    return 0
}

is_file_extension() {
    local INPUT_FILE="${1}"
    local EXPECTED_EXTENSION="${2}"
    local ACTUAL_EXTENSION="${INPUT_FILE#*.}"
    if [[ "${INPUT_FILE}" == "" ]] || [[ "${ACTUAL_EXTENSION,,}" != "${EXPECTED_EXTENSION,,}" ]] ; then
        return 1
    fi
    return 0
}

files_with_no_date() {
    local FOLDER="${1}"
    pushd "${FOLDER}" > /dev/null 2>&1
    for file in *; do
        if ! [[ "${file}" =~ ^.+_([0-9]{8})(\..+)?$ ]] ; then
            echo "${file}"
        fi
    done
    popd > /dev/null 2>&1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    download_jtcores "${1}"
fi