{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/server
  ];

  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.secrets.pass = {};

  networking = {
    hostName = "dagobert";
    networkmanager.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # the user account on the machine
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$wC0PJhkoBmLJAqsM$R7zFvUuK7rnHhZw8XQd6PXW41q7wv2ftw3k3sEh97sBdZD6vFJxTYRJKMUn5Hnn.jMhYQa8kuGSCPM6e7HFvu/";
  };

  # this allows you to run `nixos-rebuild --target-host admin@this-machine` from a different host.
  nix.settings.trusted-users = [ "admin" ];

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  environment.variables = {
    EDITOR = "neovim";
  };
  
  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "sv-latin1";
}


