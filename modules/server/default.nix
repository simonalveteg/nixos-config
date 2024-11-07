
{ config, lib, pkgs, ... }:

{
  sops.age.sshKeyPaths = [ "/home/skarv/.ssh/id_ed25519" ];
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.secrets.wireguard = { 
    owner = "root"; 
    sopsFile = ./mullvad.yaml;
  };

  imports = [];
  users.groups.media = {};

  vpnNamespaces.mullvad = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguard.path;
    accessibleFrom = [
      "192.168.1.0/24"
      "10.0.0.0/8"
      "127.0.0.1/32"
    ];
    portMappings = [
      { from = 9091; to = 9091; } # UI Port.
    ];
    openVPNPorts = [{
      port = 51413; # Peer port. Mullvad doesn't support port forwarding so this won't have an effect?
      protocol = "both";
    }];
  };
  
  systemd.services.transmission.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  services = {
    mullvad-vpn.enable = true;
    transmission = {
      enable = true;
      group = "media";
      openPeerPorts = true;
      settings = {
        download-dir = "/mnt/jellyfin/torrents";
        rpc-bind-address = "0.0.0.0"; # Bind RPC/WebUI to bridge address. Doesn't work??
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
        peer-port = 51413;
        utp-enabled = false;
      };
    };
    jellyfin = {
      enable = true; # 8096
      group = "media";
    };
    jellyseerr = {
      enable = true; # 5055
    };
    prowlarr = {
      enable = true; # 9696
    };
    sonarr = {
      enable = true; # 8989
      group = "media";
    };
    radarr = {
      enable = true; #7878
      group = "media";
    };
    bazarr = {
      enable = true; #6767
      group = "media";
    };
  };
}
