{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/jellyfin/config:/config"
        "/media/media/tv:/media/tv"
        "/media/media/movies:/media/movies"
      ];
      # networks = [ "host" ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8096 ];
}
