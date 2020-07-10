#!/usr/bin/env bash
PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$"

ROOT_PATH="${PWD}"
MODE="none"
API_FILES_NAME="" # Define by user with the file with the API variables for Openstack

[ ! -d "${FOLDER_CONFIG}" ] && mkdir -p "${FOLDER_CONFIG}"

while getopts 'p:m:' flag; do
  case "${flag}" in
    p) ROOT_PATH="${OPTARG}" ;;
    m) MODE="${OPTARG}" ;;
  esac
done

FOLDER_CONFIG="${ROOT_PATH}/.control-instance-config"

printf "  Running the script in the path '%s'" "${ROOT_PATH}"
printf "\n  Running in Mode '%s'" "${MODE}"

if [ "${MODE}" == "stop" ]; then
    printf "\n      Stoping instances..."

    for API_FILE in ${API_FILES_NAME}; do
        source "${ROOT_PATH}/${API_FILE}"

        OUTPUT_FILE="${FOLDER_CONFIG}/${API_FILE/-openrc/}.txt"

        printf "\n          Executing instance %s" "${API_FILE}"
        printf "\n          Saving power off instances in to '%s'" "${OUTPUT_FILE}"

        for INSTANCE in $(openstack server list | grep ACTIVE | awk '{ print $4 }'); do
            printf "\n              - Powering off %s..." "${INSTANCE}"
            openstack server stop "${INSTANCE}"
            echo "${INSTANCE}" >> "${OUTPUT_FILE}"
            sleep 10
        done
    done
elif [ "${MODE}" == "start" ]; then
    printf "\n      Starting instances..."

    for API_FILE in ${API_FILES_NAME}; do
        source "${ROOT_PATH}/${API_FILE}"

        OUTPUT_FILE="${FOLDER_CONFIG}/${API_FILE/-openrc/}.txt"

        printf "\n          Executing instance %s" "${API_FILE}"
        printf "\n          Reading power off instances of %s" "${OUTPUT_FILE}"

        if [ -f "${OUTPUT_FILE}" ]; then
            while IFS= read -r INSTANCE; do
                printf "\n              - Powering up %s" "${INSTANCE}"
                openstack server start "${INSTANCE}"
                sleep 60
            done < "$OUTPUT_FILE"

            printf "\n          Deleting file with saved power off instances..."
            rm "$OUTPUT_FILE"
        else
            printf "\n          Don't exist saved power off instances"
        fi
    done
else
    printf "\n      Mode '%s' not supported..." "${MODE}"
fi

printf "\n"
