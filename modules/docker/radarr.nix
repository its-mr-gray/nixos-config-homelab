{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/radarr:/config"
        "/fast/torrents:/downloads"
        "/media/media/movies:/movies"
      ];
      ports = [
        "7878:7878"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 7878 ];
}
