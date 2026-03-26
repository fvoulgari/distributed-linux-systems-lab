#!/bin/bash
set -u

lock_file="/tmp/health_check.lock"
exec 200>"$lock_file"
flock -n 200 || exit 1

timestamp="$(date '+%F %T')"
host="$(hostname)"

log_root="/mnt/shared/logs"
host_log_dir="${log_root}/${host}"
log_file="${host_log_dir}/${host}_$(date '+%Y%m%d_%H%M%S').log"

cpu_threshold=80
mem_threshold=80
disk_threshold=80
loadavg_threshold=1.0

mkdir -p "$host_log_dir"

echo "================================================================" > "$log_file"
echo "=== System Health Check for $host at $timestamp ===" >> "$log_file"
echo "================================================================" >> "$log_file"
echo >> "$log_file"

cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)
echo "CPU Usage: ${cpu_usage}%" >> "$log_file"
if [[ "$cpu_usage" -gt "$cpu_threshold" ]]; then
  echo "WARNING: High CPU usage ${cpu_usage}%" >> "$log_file"
fi
echo >> "$log_file"

mem_usage=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')
echo "Memory Usage: ${mem_usage}%" >> "$log_file"
if [[ "$mem_usage" -gt "$mem_threshold" ]]; then
  echo "WARNING: High memory usage ${mem_usage}%" >> "$log_file"
fi
echo >> "$log_file"

load_average=$(awk '{print $1}' /proc/loadavg)
echo "Load Average (1m): $load_average" >> "$log_file"
if (( $(echo "$load_average > $loadavg_threshold" | bc -l) )); then
  echo "WARNING: High load average $load_average" >> "$log_file"
fi
echo >> "$log_file"

df -h --output=source,pcent,target | awk '/^\/dev\// {print $1, $2, $3}' | while read -r device usage mount; do
  usage_percent="${usage%%%}"
  echo "Disk Usage on $mount ($device): $usage" >> "$log_file"
  if [[ "$usage_percent" -gt "$disk_threshold" ]]; then
    echo "WARNING: High disk usage on $mount ($usage)" >> "$log_file"
  fi
done
echo >> "$log_file"

echo "Top 5 CPU Consuming Processes:" >> "$log_file"
echo "---------------------------------" >> "$log_file"
ps --sort=-%cpu -eo pid,%cpu,comm | head -n 6 >> "$log_file"
echo >> "$log_file"

echo "Top 5 Memory Consuming Processes:" >> "$log_file"
echo "---------------------------------" >> "$log_file"
ps --sort=-%mem -eo pid,%mem,comm | head -n 6 >> "$log_file"
echo >> "$log_file"

echo "Status of important services:" >> "$log_file"
services=("ssh" "nginx")
for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    status="Running"
  else
    status="Stopped"
    echo "WARNING: Service $service is not running!" >> "$log_file"
  fi
  echo "Service $service: $status" >> "$log_file"
done
echo >> "$log_file"

echo "================================================================" >> "$log_file"
echo "================= System Health Check Complete =================" >> "$log_file"
echo "================================================================" >> "$log_file"

echo "System health check completed. See $log_file for details."