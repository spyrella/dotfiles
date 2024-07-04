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
   mkdir -p Work && cd Work
   git clone https://github.com/spyrella/dotfiles.git
   cd dotfiles
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
   nixos-generate-config --root /mnt \
   && rm -f ./nixos/hardware-configuration.nix \
   && cp -i /mnt/etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
   ```

7. **Apply your system configuration:**

   ```bash
   nixos-install --flake .#nixos
   ```

8. **Setup home manager & apply your home configuration:**

   ```bash
   nix shell nixpkgs#home-manager --extra-experimental-features 'nix-command flakes'
   ```

9. **Reboot system**

## Post-Installation Setup

1. **Reset Password:**

    ```bash
    passwd
    ```

2. **Clone the configuration repository and navigate to it:**

      ```bash
      mkdir -p Work && cd Work
      git clone https://github.com/spyrella/dotfiles.git
      cd dotfiles
      ```

3. **Replace hardware-configuration:**

    ```bash
    rm -f ./nixos/hardware-configuration.nix && cp -i /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
    ```

4. **Rebuild System & Home Manager:**

    ```bash
    sudo nixos-rebuild switch --flake .#nixos
    ```

    ```bash
    home-manager switch --flake .#ks@nixos
    ```

5. **Reboot system**

6. **Use the following commands instead:**

    ```bash
    nh os switch
    ```

    ```bash
    nh home switch
    ```