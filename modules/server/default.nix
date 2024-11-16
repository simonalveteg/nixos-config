
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
    # The address at which the confined services will be accessible.
    namespaceAddress = "192.168.15.1"; 
    accessibleFrom = [
      "192.168.0.0/16"
      "10.0.0.0/8"
      "127.0.0.1/32"
    ];
    portMappings = [
      { from = 8112; to = 8112; } # UI Port.
    ];
    openVPNPorts = [{
      port = 58846; # Peer port. 
      protocol = "both";
    }];
  };
  
  systemd.services.deluged.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };
  # Required so that the web ui can find the daemon
  systemd.services.delugeweb.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  services = {
    deluge = {
      enable = true;
      group = "media";
      declarative = true;
      web = {
      	enable = true;
        openFirewall = true;
      };
      openFirewall = true;
      config = {
        download_location = "/media/hdd/jellyfin/torrents";
        enabled_plugins = [
            "Label"
            "WebUi"
        ];
      };
      authFile = pkgs.writeTextFile {
        name = "deluge-auth";
      	text = "localclient:deluge:10\n";
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
