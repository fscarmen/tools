#!/usr/bin/env bash
#===============================================================================
# keepalive-upgrade.sh — 旧版 WARP 一键升级内置保活
#
# 适用: 已用旧版 menu.sh 安装 WARP, 想升级到含自动保活 (keepalive.sh)
# 逻辑: 检查 ready -> 停 warp -> 生成保活文件 -> 注入 PostUp/PostDown -> 重跑 warp
# 语言: 从 /etc/wireguard/language 读取 (E=English, C=简体中文), 默认 English
#===============================================================================
set -u

CONF="/etc/wireguard/warp.conf"
KEEPALIVE="/etc/wireguard/keepalive.sh"

# ---------- 语言 ----------
[ -s /etc/wireguard/language ] && L=$(cat /etc/wireguard/language) || L=E

# ---------- 输出 ----------
info() { echo -e "\033[32m\033[01m$*\033[0m"; }
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }
warn() { echo -e "\033[31m\033[01m$*\033[0m"; }

E_MSG=(
  "[OK] Keepalive upgrade started. All prerequisites are ready."
  "[OK] WARP interface has been brought down."
  "[OK] keepalive.sh has been generated."
  "[OK] PostUp/PostDown have been injected into warp.conf."
  "[OK] WARP is running again with auto keepalive enabled."
  "[FAIL] warp is not installed or /etc/wireguard/warp.conf is missing. Nothing to do."
  "[FAIL] Required command not found:"
  "[FAIL] Failed to restart WARP. Please check warp status."
  "Keepalive checks every 5 minutes and runs [warp n] when the WARP interface drops, preventing network loss."
)
C_MSG=(
  "[成功] 保活升级开始，前置检查全部就绪。"
  "[成功] WARP 接口已停止。"
  "[成功] 保活脚本已生成。"
  "[成功] PostUp/PostDown 已注入 warp.conf。"
  "[成功] WARP 已重新运行，自动保活已生效。"
  "[失败] WARP 未安装或 /etc/wireguard/warp.conf 不存在。"
  "[失败] 缺少必需命令:"
  "[失败] WARP 重启失败，请检查 warp 状态输出。"
  "保活每 5 分钟检测一次，WARP 掉线时自动执行 warp n 重新获取 IP，避免网络中断。"
)

# ---------- 检查 ----------
[ "$(id -u)" != 0 ] && { [ "$L" = C ] && echo "${C_MSG[6]} root" || echo "${E_MSG[6]} root"; exit 1; }
[ -f "$CONF" ] || { [ "$L" = C ] && echo "${C_MSG[5]}" || echo "${E_MSG[5]}"; exit 1; }
for c in wg wg-quick warp ps sed; do
  command -v "$c" >/dev/null 2>&1 || { [ "$L" = C ] && echo "${C_MSG[6]} $c" || echo "${E_MSG[6]} $c"; exit 1; }
done

[ "$L" = C ] && echo "${C_MSG[0]}" || echo "${E_MSG[0]}"

# ---------- 1. 停旧 WARP ----------
wg-quick down warp >/dev/null 2>&1
# 追加: 若原本还有保活进程也一并停掉(防止旧残留)
ps -ef 2>/dev/null | grep -v grep | grep -q 'keepalive.sh loop' && {
  for p in $(ps -ef 2>/dev/null | grep '[k]eepalive.sh loop' | awk '{print $2}'); do
    [ "$p" != "$$" ] && kill "$p" 2>/dev/null
  done
}
[ "$L" = C ] && echo "${C_MSG[1]}" || echo "${E_MSG[1]}"

# ---------- 2. 生成保活文件(与 menu.sh 完全一致) ----------
# 与 menu.sh 的 heredoc 逐字一致
cat > "$KEEPALIVE" <<'EOF'
#!/usr/bin/env bash
set -u
LOCK=/var/run/warp-keepalive.lock
HAVE_FLOCK=0
command -v flock >/dev/null 2>&1 && HAVE_FLOCK=1
case "${1:-}" in
  start)
    if [ "$HAVE_FLOCK" = 1 ]; then
      # flock 原子锁，无竞态：拿不到锁说明已有实例。子进程继承 fd 9 持锁，loop 结束自动释放
      exec 9>"$LOCK"
      flock -n 9 || exit 0
    else
      # 无 flock(如 busybox/Alpine) 回退 ps+grep 检测
      ps -ef 2>/dev/null | grep -q '[k]eepalive.sh loop' && exit 0
    fi
    nohup "$0" loop >/dev/null 2>&1 &
    ;;
  stop)
    # 不删锁文件，kill 掉 loop 后 fd 9 自动关闭释放锁，避免新建 inode 造成二次竞态
    for p in $(ps -ef 2>/dev/null | grep '[k]eepalive.sh loop' | awk '{print $2}'); do
      [ "$p" != "$$" ] && kill "$p" 2>/dev/null
    done
    ;;
  loop)
    while true; do
      wg | grep -q 'warp' && warp n >/dev/null 2>&1
      sleep "${INTERVAL:-5m}"
    done
    ;;
esac
EOF
chmod +x "$KEEPALIVE"
[ "$L" = C ] && echo "${C_MSG[2]}" || echo "${E_MSG[2]}"

# ---------- 3. 注入 PostUp/PostDown(幂等, 插到最后一条 ^PostDown 行之后) ----------
if grep -q 'keepalive.sh start' "$CONF"; then
  :
else
  awk '{ line[NR]=$0 } /^PostDown =/ { last=NR } END { for (i=1;i<=NR;i++) { print line[i]; if (i==last) { print "PostUp   = /etc/wireguard/keepalive.sh start"; print "PostDown = /etc/wireguard/keepalive.sh stop" } } }' "$CONF" > "${CONF}.tmp" && mv -f "${CONF}.tmp" "$CONF"
fi
[ "$L" = C ] && echo "${C_MSG[3]}" || echo "${E_MSG[3]}"

# ---------- 4. 重跑 warp ----------
if warp n >/dev/null 2>&1; then
  [ "$L" = C ] && echo "${C_MSG[4]}" || echo "${E_MSG[4]}"
else
  [ "$L" = C ] && echo "${C_MSG[7]}" || echo "${E_MSG[7]}"
fi

# ---------- 5. 结果提示 ----------
[ "$L" = C ] && hint " ${C_MSG[8]} " || hint " ${E_MSG[8]} "
