{ config, lib, pkgs, ... }:
let
  runtimePath = lib.makeBinPath (with pkgs; [
    bash coreutils gnugrep gnused findutils jq imagemagick
    sway systemd dunst foot procps fuzzel python3 fontconfig waybar
  ]);
in
{
  home.file.".config/rice/reference/773.jpg".source = ./wallpaper/773.jpg;
  home.file.".config/rice/reference/WALLPAPER-LICENSE.txt".source = ./wallpaper/WALLPAPER-LICENSE.txt;
  home.file.".config/sway/config".source = ./sway/config;

  home.file.".local/bin/theme-sync" = { source = ./scripts/theme-sync; executable = true; };
  home.file.".local/bin/set-wallpaper" = { source = ./scripts/set-wallpaper; executable = true; };
  home.file.".local/bin/wallpaper-menu" = { source = ./scripts/wallpaper-menu; executable = true; };
  home.file.".local/bin/rice-status" = { source = ./scripts/rice-status; executable = true; };
  home.file.".local/bin/rice-session" = { source = ./scripts/rice-session; executable = true; };
  home.file.".local/bin/rice-layout" = { source = ./scripts/rice-layout; executable = true; };
  home.file.".local/bin/rice-foot" = { source = ./scripts/rice-foot; executable = true; };
  home.file.".local/bin/rice-fetch" = { source = ./scripts/rice-fetch; executable = true; };
  home.file.".local/bin/rice-yazi" = { source = ./scripts/rice-yazi; executable = true; };
  home.file.".local/bin/torrents" = { source = ./scripts/torrents; executable = true; };
  home.file.".local/bin/torrents-stop" = { source = ./scripts/torrents-stop; executable = true; };
  home.file.".local/bin/audio-lowlatency" = { source = ./scripts/audio-lowlatency; executable = true; };
  home.file.".local/bin/audio-normal" = { source = ./scripts/audio-normal; executable = true; };
  home.file.".local/bin/reaper-pw" = { source = ./scripts/reaper-pw; executable = true; };
  home.file.".local/bin/rice-doctor" = { source = ./scripts/rice-doctor; executable = true; };
  home.file.".local/bin/rice-check" = { source = ./scripts/rice-check; executable = true; };
  home.file.".local/bin/nix-sync" = { source = ./scripts/nix-sync; executable = true; };
  home.file.".local/bin/nix-test" = { source = ./scripts/nix-test; executable = true; };
  home.file.".local/bin/nix-apply" = { source = ./scripts/nix-apply; executable = true; };

  # Generate the fixed monochrome UI files during activation. The wallpaper is
  # independent from the theme and remains full-color.
  home.activation.generateRiceTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export HOME=${lib.escapeShellArg config.home.homeDirectory}
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_DATA_HOME="$HOME/.local/share"
    export PATH=${lib.escapeShellArg runtimePath}:$PATH
    export RICE_REFERENCE_WALLPAPER=${lib.escapeShellArg (toString ./wallpaper/773.jpg)}
    ${pkgs.bash}/bin/bash ${./scripts/theme-sync} --activation
  '';
}
