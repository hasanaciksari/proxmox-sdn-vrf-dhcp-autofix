#!/bin/bash

# =================================================================
#  Proxmox SDN VRF-Aware DHCP Fix - Installer
#  Lead Developer: Hasan ACIKSARI (Tulpar OÜ / BGMSoft LTD)
#  Repo: https://github.com/hasanaciksari/proxmox-sdn-vrf-dhcp-autofix/
#  License: MIT
#  Description: Fixes DHCP issues in Proxmox SDN VRF/EVPN setups.
# =================================================================

set -e

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Proxmox SDN DHCP Auto-Fix Installation...${NC}"

# 1. Root Kontrolü
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}Error: Please run as root (use sudo).${NC}"
  exit 1
fi

# 2. Gereksinim Kontrolü (dnsmasq yüklü mü?)
if ! command -v dnsmasq &> /dev/null; then
    echo -e "${BLUE}Installing dnsmasq-utils...${NC}"
    apt-get update && apt-get install -y dnsmasq
fi

# 3. Klasör Yapısı
mkdir -p /etc/systemd/system/dnsmasq@.service.d/
mkdir -p /usr/local/bin/

# 4. Dinamik VRF Helper (Systemd Override)
echo -e "${BLUE}Applying Systemd template overrides...${NC}"
cat <<EOF > /etc/systemd/system/dnsmasq@.service.d/vrf-helper.conf
[Service]
ExecStart=
ExecStart=/bin/sh -c 'VRF=\$(ip -o link show %I | grep -oP "master \K[^ ]+"); if [ -n "\$VRF" ]; then exec ip vrf exec "\$VRF" /usr/sbin/dnsmasq -C /etc/dnsmasq.d/%I -k; else exec /usr/sbin/dnsmasq -C /etc/dnsmasq.d/%I -k; fi'
EOF

# 5. DHCP Watcher Script
echo -e "${BLUE}Installing automation scripts...${NC}"
cat <<EOF > /usr/local/bin/pve-dhcp-watch.sh
#!/bin/bash
# Monitors dnsmasq config directory and ensures services are started
for file in /etc/dnsmasq.d/*; do
    [ -e "\$file" ] || continue
    interface=\$(basename "\$file")
    if ip link show "\$interface" > /dev/null 2>&1; then
        if ! systemctl is-active --quiet dnsmasq@"\$interface"; then
            echo "Starting DHCP for \$interface"
            systemctl enable --now dnsmasq@"\$interface"
        fi
    fi
done
EOF
chmod +x /usr/local/bin/pve-dhcp-watch.sh

# 6. Systemd Path & Service Units (Gözcü Mekanizması)
cat <<EOF > /etc/systemd/system/pve-sdn-watch.path
[Unit]
Description=Watch /etc/dnsmasq.d for SDN changes
After=network.target

[Path]
DirectoryNotEmpty=/etc/dnsmasq.d/
Unit=pve-sdn-watch.service

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/pve-sdn-watch.service
[Unit]
Description=Trigger DHCP services on SDN config changes

[Service]
Type=oneshot
ExecStart=/usr/local/bin/pve-dhcp-watch.sh

[Install]
WantedBy=multi-user.target
EOF

# 7. Aktivasyon
echo -e "${BLUE}Reloading systemd and enabling services...${NC}"
systemctl daemon-reload
systemctl enable --now pve-sdn-watch.path

# 8. Mevcut VNet'leri Tara (İlk kurulum için)
/usr/local/bin/pve-dhcp-watch.sh

echo -e "${GREEN}--------------------------------------------------${NC}"
echo -e "${GREEN}Success! Proxmox SDN DHCP is now VRF-aware.${NC}"
echo -e "${GREEN}New VNets will automatically start DHCP services.${NC}"
echo -e "${GREEN}--------------------------------------------------${NC}"
