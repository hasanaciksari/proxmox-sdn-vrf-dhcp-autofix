# proxmox-sdn-vrf-dhcp-autofix
Automatically fixes Proxmox SDN DHCP issues in VRF/EVPN environments. Features a dynamic systemd template override to inject 'ip vrf exec' context and an event-driven watcher for auto-starting services on new VNet creation. Essential for automated, multi-tenant Proxmox networking.
