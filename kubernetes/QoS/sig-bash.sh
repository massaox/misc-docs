#!/usr/bin/env bash
set -x

pid=0

# SIGUSR1-handler
my_handler() {
  echo "my_handler"
}

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM

# run application
node program &
pid="$!"

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done


## EXIT codes
#Exit Code 0: Absence of an attached foreground process
#Exit Code 1: Indicates failure due to application error
#Exit Code 137: Indicates failure as container received SIGKILL (Manual intervention or 'oom-killer' [OUT-OF-MEMORY])
#Exit Code 139: Indicates failure as container received SIGSEGV
#Exit Code 143: Indicates failure as container received SIGTERM
