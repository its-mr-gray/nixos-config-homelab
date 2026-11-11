{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/prowlarr:/config"
      ];
      ports = [
        "9696:9696"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 9696 ];
}
