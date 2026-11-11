{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";

    containers.qbittorrent = {
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "America/New_York";
        WEBUI_PORT = "6880";
        TORRENTING_PORT = "6881";
      };
      volumes = [
        "/fast/qbittorrent:/config"
        "/fast/torrents:/downloads"
      ];
      dependsOn = [ "gluetun" ];
      extraOptions = [ "--network=container:gluetun" ];
      autoStart = true;
    };
  };
}
