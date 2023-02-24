#!/usr/bin/env bash
# Copyright (c) 2021 José Manuel Barroso Galindo <theypsilon@gmail.com>

set -euo pipefail

curl -o /tmp/update_distribution.source "https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/develop/.github/update_distribution.sh"

source /tmp/update_distribution.source
rm /tmp/update_distribution.source

curl -o /tmp/calculate_db.py "https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/develop/.github/calculate_db.py"
chmod +x /tmp/calculate_db.py

update_jtcores() {
    local OUTPUT_FOLDER="$(cd ${1} ; pwd)"
    local PUSH_COMMAND="${2:-}"

    fetch_core_urls

    local TMP_FOLDER="$(mktemp -d)"
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

    for mra in $(find mra -type f -iname '*.mra' -not -path "*/_alternatives/*") ; do
        echo copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
        copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
    done

    pushd mra

    for alts in $(find _alternatives/ -type f -iname '*.mra') ; do
        echo copy_file "${alts}" "${OUTPUT_FOLDER}/_Arcade/${alts}"
        copy_file "${alts}" "${OUTPUT_FOLDER}/_Arcade/${alts}"
    done

    popd
    popd

    if [[ "${PUSH_COMMAND}" == "--push" ]] ; then
        git checkout -f develop -b main
        echo "Running detox"
        detox -v -s utf_8-only -r *
        echo "Detox done"
        git add "${OUTPUT_FOLDER}"
        git commit -m "-"
        git fetch origin main || true
        if ! git diff --quiet main origin/main^ ; then
            echo "Calculating db..."
            /tmp/calculate_db.py
        else
            echo "Nothing to be updated."
        fi
    fi

    rm -rf "${TMP_FOLDER}"
}

fetch_core_urls() {
    CORE_URLS=$(curl -sSLf "https://github.com/jotego/jtbin/wiki"| awk '/Arcade-Cores-Top/,/Arcade-Cores-Bottom/' | grep -ioE "https://github.com/jotego/jtbin/tree/[a-zA-Z0-9./_-]*")
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    update_jtcores "${1}" "${2:-}"
fi
