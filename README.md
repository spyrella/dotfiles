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
   git clone https://github.com/test/nix-config.git
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

6. **Generate config & apply your system configuration:**

   ```bash
   nixos-generate-config --root /mnt && nixos-install --flake .#nixos
   ```

7. **Setup home manager & apply your home configuration:**

   ```bash
   home-manager switch --flake .#ks@nixos
   ```

    (If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.)

8. **Reboot system**
