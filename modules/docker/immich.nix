{ config, pkgs, ... }:

let
  uploadLocation = "/fast/immich/library"; # or "/fast/immich/library" if you prefer SSD
  dbDataLocation = "/fast/immich/postgres";
  modelCache = "/fast/immich/model-cache";

  dbPassword = config.sops.secrets.immich_env.path;
in
{
  systemd.services.docker-immich-net = {
    description = "Create Docker network for Immich";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.docker}/bin/docker network create immich-net || true";
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      immich-server = {
        image = "ghcr.io/immich-app/immich-server:v3";
        autoStart = true;
        dependsOn = [
          "immich-redis"
          "immich-database"
        ];
        environment = {
          TZ = "America/New_York";
          DB_HOSTNAME = "immich-database";
          DB_PORT = "5432";
          DB_USERNAME = "postgres";
          DB_PASSWORD = dbPassword;
          DB_DATABASE_NAME = "immich";
          REDIS_HOSTNAME = "immich-redis";
          IMMICH_LOG_LEVEL = "log";
        };
        volumes = [
          "${uploadLocation}:/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
        ports = [ "2283:2283" ];
        extraOptions = [ "--network=immich-net" ];
      };

      immich-machine-learning = {
        image = "ghcr.io/immich-app/immich-machine-learning:v3";
        autoStart = true;
        environment = {
          TZ = "America/New_York";
          MACHINE_LEARNING_MODEL_REVISION = "v2";
        };
        volumes = [
          "${modelCache}:/cache"
        ];
        extraOptions = [ "--network=immich-net" ];
      };

      immich-redis = {
        image = "docker.io/valkey/valkey:9";
        autoStart = true;
        extraOptions = [ "--network=immich-net" ];
      };

      immich-database = {
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0";
        autoStart = true;
        environment = {
          POSTGRES_PASSWORD = dbPassword;
          POSTGRES_USER = "postgres";
          POSTGRES_DB = "immich";
          POSTGRES_INITDB_ARGS = "--data-checksums";
        };
        volumes = [
          "${dbDataLocation}:/var/lib/postgresql/data"
        ];
        extraOptions = [
          "--network=immich-net"
          "--shm-size=128m"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 2283 ];

  systemd.tmpfiles.rules = [
    "d ${uploadLocation} 0755 1000 100 -"
    "d ${dbDataLocation} 0755 999 999 -"
    "d ${modelCache} 0755 1000 100 -"
  ];
}
