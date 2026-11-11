{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.gluetun = {
      image = "qmcgaw/gluetun:latest";
      environment = {
        VPN_SERVICE_PROVIDER = "private internet access";
        SERVER_REGIONS = "Switzerland";
        VPN_PORT_FORWARDING = "on";
        PORT_FORWARD_ONLY = "true";
      };
      environmentFiles = [
        config.sops.secrets.pia_env.path
      ];
      volumes = [
        "/fast/gluetun:/gluetun"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun"
      ];
      ports = [
        "6880:6880" # qbittorrent web ui
        "6881:6881" # qbittorrent torrenting port
      ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [
    6880
    6881
  ];
}
