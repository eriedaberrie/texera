#!/usr/bin/env bash

if [ ! -f /.dockerenv ] && [ "$1" != -f ] ; then
	>&2 echo 'This script should only be run inside Docker.'
	exit 1
fi

for sig in INT TERM ; do
	trap "kill -$sig \$(jobs -p)" "SIG$sig"
done
unset sig

bash scripts/server.sh &
bash scripts/worker.sh &

wait
