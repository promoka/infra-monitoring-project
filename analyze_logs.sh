#!/usr/bin/env bash
set -euo pipefail

log_file="${1:-access.log}"

# ??????? 300 ??????? ? ??????????? IP-???????? ? ???????? 2xx, 4xx ? 5xx.
ips=("192.168.1.10" "10.0.0.5" "172.16.0.8" "192.168.1.20" "10.0.0.15")
methods=("GET" "POST" "GET" "GET" "POST")
paths=("/api/users" "/api/login" "/api/status" "/api/items" "/api/login")
codes=(200 401 200 404 500)

: > "$log_file"
for i in $(seq 1 300); do
  index=$(( (i - 1) % 5 ))
  second=$(( (i - 1) % 60 ))
  printf '%s - - [15/Aug/2026:10:15:%02d] "%s %s HTTP/1.1" %s\n' \
    "${ips[$index]}" "$second" "${methods[$index]}" "${paths[$index]}" "${codes[$index]}" >> "$log_file"
done

echo "Файл $log_file создан: $(grep -Ec '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$log_file") записей"
echo "Общее количество запросов: $(grep -Ec '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$log_file")"
echo "Топ-3 IP-адреса по числу запросов:"
grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 3

awk '
  $8 ~ /^4[0-9][0-9]$/ { count4++ }
  $8 ~ /^5[0-9][0-9]$/ { count5++ }
  END {
    printf "Количество ответов с кодами 4xx: %d\n", count4
    printf "Количество ответов с кодами 5xx: %d\n", count5
  }
' "$log_file"
