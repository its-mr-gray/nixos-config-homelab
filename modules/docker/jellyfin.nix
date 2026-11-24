{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.jellyfin = {
      image = "dotwee/jellyfin-yt-dlp:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/jellyfin/config:/config"
        "/media/media/tv:/media/tv"
        "/media/media/movies:/media/movies"
        "/media/media/anime:/media/anime"
        "/media/media/youtube:/media/youtube"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8096 ];
}
