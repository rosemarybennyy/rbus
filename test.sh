#!/bin/bash

# Access the environment variables
echo "The value of MY_VARIABLE is: $MY_VARIABLE"
echo "The value of ANOTHER_VARIABLE is: $ANOTHER_VARIABLE"

#valgrind --leak-check=full --show-leak-kinds=all $MY_VARIABLE/multiRbusOpenProvider

set -xeu

prepare_valgrind_flags() {
    SUPPRESSIONS_FILE="valgrind.supp"

    echo "--leak-check=full"
    echo "--track-origins=yes"
    echo "--read-var-info=yes"
    echo "--trace-children=yes"
    echo "--show-leak-kinds=all"
    echo "--read-inline-info=yes"
    echo "--errors-for-leak-kinds=all"
    echo "--expensive-definedness-checks=yes"
    echo "--gen-suppressions=all"
    echo "--redzone-size=${INPUT_REDZONE_SIZE}"
    [ "${INPUT_TRACK_FILE_DESCRIPTORS}" = "true" ] && echo "--track-fds=yes"
    [ "${INPUT_VERBOSE}" = "true" ] && echo "--verbose"
    if [ "${INPUT_VALGRIND_SUPPRESSIONS}" != "" ]; then
        echo "${INPUT_VALGRIND_SUPPRESSIONS}" > "${SUPPRESSIONS_FILE}"
        echo "--suppressions=${SUPPRESSIONS_FILE}"
    fi
}

skip_criterion_pipe_leaks() {
    # Reason of this skip: https://github.com/Snaipe/Criterion/issues/533
    if [ "$(echo "${1}" | grep "^==.*==    by 0x.*: stdpipe_options (in /usr/local/lib/libcriterion.so.3.2.0)")" = "" ] &&
       [ "$(echo "${1}" | grep "^==.*== Open file descriptor .*: /dev/shm/bxf_arena_.* (deleted)")" = "" ]; then
        echo "1"
    else
        echo "0"
    fi
}

parse_valgrind_reports() {
    VALGRIND_REPORTS="${1}"
    VALGRIND_RULES="
        ^==.*== .* bytes in .* blocks are definitely lost in loss record .* of .*
        ^==.*== .* bytes in .* blocks are still reachable in loss record .* of .*
        ^==.*== Invalid .* of size .*
        ^==.*== Open file descriptor .*: .*
        ^==.*== Invalid free() / delete / delete\[\] / realloc()
        ^==.*== Mismatched free() / delete / delete \[\]
        ^==.*== Syscall param .* points to uninitialised byte(s).*
        ^==.*== Source and destination overlap in .*
        ^==.*== Argument .* of function .* has a fishy (possibly negative) value: .*
        ^==.*== .*alloc() with size 0
        ^==.*== Invalid alignment value: .* (should be power of 2)
    "
    report_id=1
    status=0
    error=""
    kind="error"

    [ "${INPUT_TREAT_ERROR_AS_WARNING}" = "true" ] && kind="warning"
    while IFS= read -r line; do
        if [ "${error}" != "" ]; then
            if [ "$(echo "${line}" | grep '^==.*== $')" ] && [ "$(skip_criterion_pipe_leaks "${error}")" = "1" ]; then
                echo "::${kind} title=Valgrind Report '${INPUT_BINARY_PATH}' (${report_id})::${error}"
                report_id=$(( report_id + 1 ))
                error=""
                status=1
            else
                error="${error}%0A${line}"
            fi
        fi
        for rule in ${VALGRIND_RULES}; do
            if [ "$(echo "${line}" | grep "${rule}")" ]; then
                error="${line}"
                break
            fi
        done
    done < "${VALGRIND_REPORTS}"
    rm -f "${VALGRIND_REPORTS}"
    [ "${kind}" = "warning" ] && exit 0 || exit "${status}"
}

main() {
    VALGRIND_REPORTS="valgrind-reports.log"
    VALGRIND_FLAGS=$(prepare_valgrind_flags)

    if [ "${INPUT_LD_LIBRARY_PATH}" = "" ]; then
        export LD_LIBRARY_PATH="${INPUT_LD_LIBRARY_PATH}"
    fi
    set +e
    timeout ${INPUT_TIMEOUT} valgrind $VALGRIND_FLAGS "$MY_VARIABLE/multiRbusOpenProvider"  2>"${VALGRIND_REPORTS}"
    set -e
    parse_valgrind_reports "${VALGRIND_REPORTS}"
}

main

