#!/bin/bash -e

echo "[INFO] Starting sniproxy"
(until /usr/local/bin/sniproxy --config "/etc/sniproxy/config.yaml"; do
    if [ -f "/tmp/reload_sni_proxy" ];
    then
      # ignore => restarted by cron
      rm -f /tmp/reload_sni_proxy
    else
      echo "[WARN] sniproxy crashed with exit code $?. Restarting..." >&2
    fi
    sleep 1
done) &
echo "[INFO] Using EXTERNAL_IP - Point your DNS settings to this address"
wait -n
