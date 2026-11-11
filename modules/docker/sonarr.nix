{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/sonarr:/config"
        "/fast/torrents:/downloads"
        "/media/media/tv:/tv"
      ];
      ports = [
        "8989:8989"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8989 ];
}
