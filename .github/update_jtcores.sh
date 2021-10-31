#!/usr/bin/env bash
# Copyright (c) 2021 José Manuel Barroso Galindo <theypsilon@gmail.com>

set -euo pipefail

curl -o /tmp/update_distribution.source "https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/main/.github/update_distribution.sh"

source /tmp/update_distribution.source
rm /tmp/update_distribution.source

curl -o /tmp/calculate_db.py "https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/main/.github/calculate_db.py"
chmod +x /tmp/calculate_db.py

update_jtcores() {
    local OUTPUT_FOLDER="${1}"
    local PUSH_COMMAND="${2:-}"

    fetch_core_urls

    local TMP_FOLDER="$(mktemp -d)"
    download_repository "${TMP_FOLDER}" "https://github.com/jotego/jtbin.git" "master"

    mkdir -p "${OUTPUT_FOLDER}/_Arcade/cores/"

    for folder in $(echo "${CORE_URLS[@]}" | sed -n -e 's%^.*tree/master/%%p') ; do

        for bin in $(files_with_stripped_date "${TMP_FOLDER}/${folder}/releases" | uniq) ; do
            get_latest_release "${TMP_FOLDER}/${folder}" "${bin}"
            local LAST_RELEASE_FILE="${GET_LATEST_RELEASE_RET}"

            if is_not_rbf_release "${LAST_RELEASE_FILE}" ; then
                continue
            fi

            copy_file "${folder}/releases/${LAST_RELEASE_FILE}" "${OUTPUT_FOLDER}/_Arcade/cores/$(basename ${LAST_RELEASE_FILE})"
        done
    done

    local IFS=$'\n'

    pushd ${TMP_FOLDER}

    for mra in $(find mra -type f -iname '*.mra' -not -path "*/_alternatives/*") ; do
        copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
    done

    pushd mra

    for alts in $(find _alternatives/ -type f -iname '*.mra') ; do
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
    CORE_URLS=$(curl -sSLf "https://github.com/jotego/jtbin/wiki"| awk '/wiki-body/,/wiki-rightbar/' | grep -ioE "https://github.com/jotego/jtbin/tree/[a-zA-Z0-9./_-]*")
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    update_jtcores "${1}" "${2:-}"
fi
