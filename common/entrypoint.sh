#!/bin/bash

# set -x will Output all executed commands to the terminal
# this will allow for clarity in what scripts are being run and in what order.
set -x

for f in /var/www/entrypoint.d/*.sh; do
  bash "$f" -H   || break # break will stop execution if a script fails.
done

exec "$@"
