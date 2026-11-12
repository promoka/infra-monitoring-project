#!/usr/bin/env bash
set -u

if [[ $# -ne 1 || -z "${1:-}" ]]; then
  echo "?????????????: $0 <URL>" >&2
  exit 1
fi

url="$1"
if ! http_code=$(curl --silent --show-error --output /dev/null \
  --write-out '%{http_code}' --connect-timeout 10 --max-time 20 "$url" 2>/dev/null); then
  http_code="000"
fi

if [[ "$http_code" == "200" ]]; then
  echo "API ????????"
  exit 0
fi

echo "API ??????????, ??? ??????: ${http_code}"
exit 1
