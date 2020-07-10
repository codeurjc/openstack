#!/usr/bin/env bash

if [ ! -z "$1" ]; then
    ROOT_PATH="$1"
else
    ROOT_PATH="${PWD}"
fi

echo "Running the script in the path: ${ROOT_PATH}"

FOLDER_INSTANCES="${ROOT_PATH}/.save-running-instances"
API_FILES_NAME="" # Define by user with the file with the API variables for Openstack

[ ! -d "${FOLDER_INSTANCES}" ] && mkdir -p "${FOLDER_INSTANCES}"

for API_FILE in ${API_FILES_NAME}; do
    source "${ROOT_PATH}/${API_FILE}"

    OUTPUT_FILE="${FOLDER_INSTANCES}/${API_FILE/-openrc/}.txt"

    for INSTANCE in $(openstack server list | grep ACTIVE | awk '{ print $4 }'); do
        echo "${INSTANCE}" >> "${OUTPUT_FILE}"
    done
done
