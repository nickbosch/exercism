#!/usr/bin/env bash

# one line solution using 'rev'
# echo "$@" | rev

main () {
    for (( i = ${#1} - 1; i >= 0; i-- )); do
        printf "${1:i:1}"
    done
}

main "$@"