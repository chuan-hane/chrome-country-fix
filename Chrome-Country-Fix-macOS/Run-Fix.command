#!/bin/bash

task_directory="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
task_result=0

if [[ "$(/usr/bin/uname -s)" != "Darwin" ]]; then
    printf '%s\n' 'ERROR: This package is for macOS.' >&2
    exit 1
fi

task_version="$(/usr/bin/sw_vers -productVersion)"
if [[ "${task_version%%.*}" -lt 13 ]]; then
    printf '%s\n' 'ERROR: macOS 13 Ventura or later is required.' >&2
    task_result=1
elif [[ ! -x "$task_directory/Fix-ChromeCountry" ]]; then
    printf '%s\n' 'ERROR: Fix-ChromeCountry is missing or not executable. See README.md.' >&2
    task_result=1
else
    "$task_directory/Fix-ChromeCountry" "$@"
    task_result=$?
fi

if [[ -t 0 ]]; then
    printf '\nPress Return to close this window...'
    IFS= read -r task_reply
fi
exit "$task_result"
