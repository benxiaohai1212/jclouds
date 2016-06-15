#!/bin/bash
set +u
shopt -s xpg_echo
shopt -s expand_aliases
unset PATH JAVA_HOME LD_LIBRARY_PATH
function abort {
   echo "aborting: $@" 1>&2
   exit 1
}
function waitForApt {
    local wait_seconds="${2:-10}" # 10 seconds as default timeout
    echo "Wait for apt to be ready..."
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
        if [ $((wait_seconds--)) -eq 0 ]; then
            echo "Wait timeout exceeded. Giving up."
            return 1
        fi
        sleep 1
    done
    return 0
}
export PATH=/usr/ucb/bin:/bin:/sbin:/usr/bin:/usr/sbin
waitForApt 10 || exit 1
exit $?
