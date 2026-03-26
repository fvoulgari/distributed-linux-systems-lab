#!/bin/bash
set -u

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <backend-hostname>"
  exit 1
fi

server="$1"
log_dir="/srv/nfs/shared/logs/${server}"
timestamp="$(date '+%F %T')"

if [[ ! -d "$log_dir" ]]; then
  echo "Directory $log_dir doesn't exist"
  exit 1
fi

latest_log="$(ls -t1 "$log_dir"/*.log 2>/dev/null | head -n 1)"

if [[ -z "$latest_log" ]]; then
  echo "Missing log file for $server"
  exit 1
fi

warnings="$(grep -i 'warning' "$latest_log")"

echo "===================================================="
echo "Healthcheck summary for $server at $timestamp"
echo "Source log: $latest_log"
echo "===================================================="

if [[ -n "$warnings" ]]; then
  echo "Total number of WARNINGS: $(echo "$warnings" | wc -l)"
  echo "----------------------------"
  echo "$warnings"
else
  echo "$server is healthy"
fi