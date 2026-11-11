{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      environment = {
        LOG_LEVEL = "info";
      };
      volumes = [
        "/fast/flaresolverr:/config"
      ];
      ports = [
        "8191:8191"
      ];
      extraOptions = [ "--network=host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8191 ];
}
