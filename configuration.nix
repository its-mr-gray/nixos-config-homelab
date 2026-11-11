{ config, pkgs, ... }:

let
  storage = {
    ssd = "/fast";
  };
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [
    ./hardware-configuration.nix
    ./modules/docker/docker.nix
    ./modules/docker/gluetun.nix
    ./modules/docker/flaresolverr.nix
    ./modules/docker/jellyfin.nix
    ./modules/docker/qbittorrent.nix
    ./modules/docker/prowlarr.nix
    ./modules/docker/radarr.nix
    ./modules/docker/sonarr.nix
    ./modules/docker/lidarr.nix
    ./modules/docker/seerr.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."homelab" = {
    isNormalUser = true;
    description = "homelab";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    parted
    curl
    #TODO: install immich when nixOS 26.11 goes stable
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.tailscale = {
    enable = true;
  };

  services.k3s = {
    enable = true;
    role = "server";
  };

  # sops
  sops = {
    age.keyFile = "/home/homelab/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;

    secrets.pia_env = { };
  };

  #firewall ports
  networking.firewall.allowedTCPPorts = [
    6443 # required so that pods can reach the API server
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 #required for multinode for internode networking
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
