# Install NixOS

## Prerequisites

- **Login as root user:**

  ```bash
  sudo su
  ```

### Installation Steps

1. **Install Neovim and Git:**

   ```bash
   nix-shell -p neovim git
   ```

2. **Clone the configuration repository and navigate to it:**

   ```bash
   git clone https://github.com/spyrella/nix-config.git
   cd nix-config
   ```

3. **Identify the disk for setup:**

   ```bash
   lsblk
   ```

4. **Modify `disko.nix` configuration as needed.**
   (Refer to [disko GitHub repository](https://github.com/nix-community/disko) for details)

5. **Partition, format, and mount the disk using `disko`:**

   ```bash
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix
   ```

6. **Generate config & replace hardware-configuration**

   ```bash
   nixos-generate-config --root /mnt && cp -i /mnt/etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
   ```

6. **Apply your system configuration:**

   ```bash
   nixos-install --flake .#nixos
   ```

8. **Setup home manager & apply your home configuration:**

   ```bash
   home-manager switch --flake .#ks@nixos
   ```

    (If you don't have home-manager installed, try `nix shell nixpkgs#home-manager --extra-experimental-features 'nix-command flakes'`)

9. **Reboot system**
