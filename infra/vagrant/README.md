# Provider Notes

This lab supports two Vagrant provider paths while keeping the system architecture unchanged. By default, Vagrant can use the standard provider resolution order.

## Supported providers
- VirtualBox
- VMWare Fusion

# Vagrant Usage

Run commands from the repository root:

cd infra/vagrant

---

## Quick Start

### Default
Uses your Vagrant default provider:
```bash
vagrant up
```

---

## Explicit Provider Selection

### VirtualBox (Intel macOS / Linux)
```bash
VAGRANT_DEFAULT_PROVIDER=virtualbox vagrant up
# or
vagrant up --provider=virtualbox
```

### VMware Fusion (Apple Silicon macOS)
```bash
VAGRANT_DEFAULT_PROVIDER=vmware_desktop vagrant up
# or
vagrant up --provider=vmware_desktop
```

---

## Notes

- The lab architecture is identical across providers.
- Ansible configuration is provider-agnostic.

---


## VirtualBox Setup

VirtualBox is free and open source. No account required.

1. Go to [virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
2. Download the installer for your platform:
   - **macOS (Intel):** macOS / Intel hosts
   - **Linux:** choose your distribution package
3. Run the installer and follow the prompts.
4. Optionally install the **VirtualBox Extension Pack** (same downloads page) — recommended for advanced networking features and USB support.
5. Verify installation:
```bash
vboxmanage --version
```

### Linux: add yourself to the vboxusers group
```bash
sudo usermod -aG vboxusers $USER
newgrp vboxusers
```

### Install Vagrant (Intel macOS / Linux)
```bash
# macOS (Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/hashicorp-vagrant

# Ubuntu / Debian
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

Verify:
```bash
vagrant --version
```

### Smoke test
```bash
vagrant up --provider=virtualbox
vagrant ssh
vagrant destroy -f
```

---

## VMware Fusion Setup

VMware Fusion Pro is free — no license key is required. When installing, you'll be asked for a license key and there will be an option to select "Personal Use" instead.

1. Go to [support.broadcom.com](https://support.broadcom.com/) and create a free account.
2. Once logged in, go to My Downloads and click **"Free Software Downloads available HERE"** in the blue banner.
3. Search for **VMware Fusion** and select **VMware Fusion 25H2** → **25H2u1** (latest update).
4.  Check the **"I agree to the Terms and Conditions"** checkbox and click the download icon.
5. You will be prompted to fill in a **Trade Compliance form** — this is a standard
   US export regulation requirement. Fill in your address details and click Submit.
   The download will start immediately after. If not click again the download button.
6. Open the `.dmg`, double-click `VMware Fusion.app`.
7. When prompted for a license key, choose "I want to license VMware Fusion Pro for Personal Use" and click Continue.
8. Verify installation:
```bash
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -v
```

### Install Vagrant (Apple Silicon macOS)
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/hashicorp-vagrant
```

Verify:
```bash
vagrant --version
```

### Install the VMware Vagrant Utility
```bash
brew install --cask vagrant-vmware-utility
```

Verify the service is running:
```bash
sudo launchctl list | grep vagrant
```

### Install the Vagrant VMware Desktop Plugin
```bash
vagrant plugin install vagrant-vmware-desktop
```

Verify:
```bash
vagrant plugin list
# Should show: vagrant-vmware-desktop (x.x.x, global)
```

### Smoke test
```bash
vagrant up --provider=vmware_desktop
vagrant ssh
vagrant destroy -f
```