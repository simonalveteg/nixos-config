
{ config, lib, pkgs, ... }:

{
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
      "192.168.0.0/16"
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
        download-dir = "/media/hdd/jellyfin/torrents";
        rpc-bind-address = "0.0.0.0"; # Bind RPC/WebUI to bridge address. Doesn't work??
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
        peer-port = 51413;
        utp-enabled = false;
      };
    };
    jellyfin = {
      enable = true; # 8096
      openFirewall = true;
      group = "media";
    };
    jellyseerr = {
      enable = true; # 5055
      openFirewall = true;
    };
    prowlarr = {
      enable = true; # 9696
      openFirewall = true;
    };
    sonarr = {
      enable = true; # 8989
      group = "media";
      openFirewall = true;
    };
    radarr = {
      enable = true; #7878
      group = "media";
      openFirewall = true;
    };
    bazarr = {
      enable = true; #6767
      group = "media";
      openFirewall = true;
    };
  };
}
