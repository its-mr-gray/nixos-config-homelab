{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tldr
    lazygit
    tree
    fzf
    eza
    fd
    yazi
    nixfmt
    zip
    unzip
    age
    sops
    ffmpeg
    yt-dlp
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "its-mr-gray";
      email = "ferrell_gray3@proton.me";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp = {
          display-messages = true;
        };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      keys = {
        normal = {
          "C-s" = ":w";
          "C-w" = ":q";
        };
        insert = {
          j = {
            j = "normal_mode";
          };
        };
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      cpn = "sudo cp -r ~/nixos-config/* /etc/nixos/";
      up = "nix flake update && sudo nixos-rebuild switch -- flake ~/nixos-config#nixos && reboot";
      ls = "eza --long --icons --git --header --icons -A";
      lg = "lazygit";
    };
  };

  home.stateVersion = "26.05";
}
