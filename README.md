# 🚀 Proxmox 9.x SDN VRF-Aware DHCP Auto-Fix
**Lead Developer:** Hasan Açıksarı | **Company:** Tulpar OÜ / BGMSoft LTD

![Proxmox Support](https://img.shields.io/badge/Proxmox-9.x-orange?style=for-the-badge&logo=proxmox)
![Developer](https://img.shields.io/badge/Developer-Hasan%20A%C3%A7%C4%B1kasar%C4%B1-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Stable-green?style=for-the-badge)

---

## 🌍 [EN] About the Project
In Proxmox SDN environments, when a **VNet** is assigned to a **VRF (Virtual Routing and Forwarding)** or **EVPN**, the standard `dnsmasq` service often fails to deliver IP addresses. This is because the service listens on the default routing table and cannot "see" requests coming from an isolated VRF.

This tool provides a dynamic, automated solution:
* **VRF Injection:** Automatically detects if a VNet is in a VRF and restarts `dnsmasq` with the correct `ip vrf exec` context.
* **Event-Driven:** A systemd path-watcher monitors `/etc/dnsmasq.d/` and starts DHCP services immediately when a new SDN network is applied.
* **Zero-Touch:** No more manual service management or template editing.



## 🇹🇷 [TR] Proje Hakkında
Proxmox SDN yapılarında, bir **VNet** bir **VRF** veya **EVPN** bölgesine atandığında, standart `dnsmasq` servisi genellikle IP dağıtamaz. Bunun sebebi, servisin varsayılan yönlendirme tablosunda (default table) çalışması ve izole edilmiş VRF'den gelen istekleri görememesidir.

Bu araç, dinamik ve tam otomatik bir çözüm sunar:
* **VRF Enjeksiyonu:** VNet'in bir VRF içinde olup olmadığını otomatik algılar ve `dnsmasq`'ı doğru `ip vrf exec` bağlamında başlatır.
* **Olay Odaklı:** Bir systemd gözcüsü `/etc/dnsmasq.d/` dizinini izler ve yeni bir network eklendiği anda DHCP servisini ayağa kaldırır.
* **Kur ve Unut:** Manuel servis yönetimi veya şablon düzenleme ihtiyacını ortadan kaldırır.

---

## 🛠️ Installation / Kurulum

Run the following command on your Proxmox node:
Proxmox node üzerinde şu komutu çalıştırın:

```bash
curl -sSL https://raw.githubusercontent.com/hasanaciksari/proxmox-sdn-vrf-dhcp-autofix/main/install.sh | bash
```
---

## ⚠️ Disclaimer / Uyarı
**[EN]:** This script is provided "as is" without any warranty. While it is designed for Proxmox 9.x environments, always perform a backup before applying changes to production systems.

**[TR]:** Bu betik "olduğu gibi" sunulmaktadır ve herhangi bir garanti vermez. Proxmox 9.x ortamları için tasarlanmış olsa da, üretim (prod) sistemlerinde değişiklik yapmadan önce mutlaka yedek alınız.



---

## 🏢 About the Developer & Company
This project is maintained by **Hasan Açıksarı**. For professional support or enterprise cloud solutions, visit our official websites:

* **TulparSoft (Global/EU):** [tulparsoft.com](https://tulparsoft.com)
* **Vexoria Cloud Services:** [vexoria.com.tr](https://vexoria.com.tr)
* **BGMSoft:** [bgm.net.tr](https://bgm.net.tr)

> **Need Help?** You can reach out for custom automation or infrastructure consultancy.

![Architecture](https://img.shields.io/badge/Architecture-x86__64-brightgreen?style=flat-square)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square)
