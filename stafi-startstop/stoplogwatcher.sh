#!/bin/bash
# gracefully stop node
collect_pid=$(pgrep restorelogwatcher)
if [ ! -z "$collect_pid" ]; then
        kill -SIGINT $collect_pid
echo "kill restorelogwatcher"
else
echo "restorelogwatcher not running"
fi
