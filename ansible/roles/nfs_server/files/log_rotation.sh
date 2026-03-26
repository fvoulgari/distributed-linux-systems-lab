#!/bin/bash
set -u

log_root="/srv/nfs/shared/logs"
backend_servers=("backend-a" "backend-b")

for server in "${backend_servers[@]}"; do
    dir="${log_root}/${server}"
    archive="${dir}/archive"

    if [[ ! -d "$dir" ]]; then
        echo "WARN: log directory $dir is missing"
        continue
    fi

    if [[ ! -d "$archive" ]]; then
        echo "WARN: archive folder is missing for $server, creating it"
        mkdir -p "$archive"
    fi

    find "$dir" -maxdepth 1 -type f -name "*.log" -mmin +5 -exec sh -c '
        archive="$1"
        shift
        for file in "$@"; do
            gzip "$file"
            mv "${file}.gz" "$archive/"
        done
    ' sh "$archive" {} +

    find "$archive" -type f -name "*.gz" -mtime +5 -delete
done