#!/bin/bash
set -e

echo "===================================="
echo " Cloudflared One-shot Health Check"
echo "===================================="

WEB_PORT=65530
METRICS_PORT=65531
TMP="/tmp/cf-health"

CF_PID=""
HTTP_PID=""

# -----------------------------
# cleanup
# -----------------------------
cleanup() {
  echo ""
  echo "[CLEAN] Stopping processes..."

  pkill -f "httpd.*$TMP" 2>/dev/null || true
  pkill -f "cloudflared.*trycloudflare" 2>/dev/null || true

  [ -n "$HTTP_PID" ] && kill "$HTTP_PID" 2>/dev/null || true
  [ -n "$CF_PID" ] && kill "$CF_PID" 2>/dev/null || true

  rm -rf "$TMP" 2>/dev/null || true
  rm -f cloudflared cf.log 2>/dev/null || true

  echo "[CLEAN] Done"
}
trap cleanup EXIT INT TERM

# -----------------------------
# 1. cleanup old
# -----------------------------
echo "[1/5] Cleaning old processes..."
pkill -f "httpd" 2>/dev/null || true
pkill -f "cloudflared" 2>/dev/null || true
sleep 1

# -----------------------------
# 2. start backend
# -----------------------------
echo "[2/5] Starting backend..."

rm -rf "$TMP"
mkdir -p "$TMP"
cd "$TMP"

echo "Hello Cloudflared" > index.html

busybox httpd -f -p $WEB_PORT -h $TMP &
HTTP_PID=$!

# -----------------------------
# 3. download cloudflared
# -----------------------------
echo "[3/5] Downloading cloudflared..."

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
  CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
elif [ "$ARCH" = "aarch64" ]; then
  CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
else
  echo "❌ Unsupported arch: $ARCH"
  exit 1
fi

busybox wget -q "$CF_URL" -O cloudflared
chmod +x cloudflared

# -----------------------------
# 4. start tunnel
# -----------------------------
echo "[4/5] Starting tunnel..."

./cloudflared tunnel \
  --metrics 127.0.0.1:$METRICS_PORT \
  --url http://127.0.0.1:$WEB_PORT \
  >/dev/null 2>&1 &

CF_PID=$!

# -----------------------------
# 5. get URL (retry)
# -----------------------------
echo "[5/5] Detecting tunnel URL..."

URL=""

for i in $(seq 1 12); do
  sleep 2

  URL=$(busybox wget -qO- "http://127.0.0.1:${METRICS_PORT}/quicktunnel" 2>/dev/null | awk -F '"' '{print $4}')

  [ -n "$URL" ] && break
done

if [ -z "$URL" ]; then
  echo "❌ FAILED: no tunnel URL (timeout)"
  exit 1
fi

echo "===================================="
echo "✔ Tunnel URL: $URL"
echo "===================================="

sleep 5

# -----------------------------
# health check (retry 3 times)
# -----------------------------
OK=0
BODY=""

for i in $(seq 1 20); do
  BODY=$(busybox wget -qO- "$URL" 2>/dev/null || true)

  if echo "$BODY" | grep -qi "hello cloudflared"; then
    OK=1
    break
  fi

  sleep 2
done

echo "Response preview:"
echo "$BODY" | head -n 3

if [ "$OK" -eq 1 ]; then
  echo "===================================="
  echo "✅ SUCCESS: cloudflared OK"
  echo "===================================="
else
  echo "===================================="
  echo "⚠ WARNING: reachable but mismatch"
  echo "===================================="
fi

exit 0