{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.lidarr = {
      image = "lscr.io/linuxserver/lidarr:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/lidarr:/config"
        "/fast/torrents:/downloads"
      ];
      ports = [
        "8686:8686"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8686 ];
}
