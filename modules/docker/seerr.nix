{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.seerr = {
      image = "ghcr.io/seerr-team/seerr:latest";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "/fast/seerr:/config"
      ];
      ports = [
        "5055:5055"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 5055 ];
}
