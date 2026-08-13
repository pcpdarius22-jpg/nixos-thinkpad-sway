{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Conservative, recoverable boot path. Keep several known-good entries.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
    editor = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "threadirqs"
    "snd_hda_intel.power_save=1"
  ];

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true;

  # ThinkPad T440: Haswell i5-4300U + Intel HD 4400.
  environment.variables.LIBVA_DRIVER_NAME = "i965";
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # 4 GB RAM: use compressed swap, but do not invent another SSD swapfile.
  # The actual T440 already has disk swap in its real hardware configuration;
  # keeping disk swap hardware-owned avoids silently stacking another 4 GiB file.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  systemd.oomd.enable = true;

  # Keep only a few system generations and garbage-collect old store paths
  # weekly. configurationLimit above only trims the boot menu; without this
  # the Nix store grows without bound on the 500 GB SSD.
  systemd.services.nixos-generation-trimmer = {
    description = "Trim old NixOS system generations";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations +3 || true
      ${pkgs.nix}/bin/nix-collect-garbage
    '';
  };
  systemd.timers.nixos-generation-trimmer = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };
  services.thermald.enable = true;
  services.fstrim.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Native Wayland desktop. XWayland is retained only for legacy applications;
  # the tiny edge text is native Wayland (Waybar with a fully transparent layer).
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
    extraPackages = [ ];
    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
    '';
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  fonts.packages = with pkgs; [
    ultimate-oldschool-pc-font-pack
    nerd-fonts.symbols-only
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = [ "PxPlus IBM VGA 8x16" ];
    sansSerif = [ "PxPlus IBM VGA 8x16" ];
    serif = [ "PxPlus IBM VGA 8x16" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    unzip
    libva-utils
  ];

  users.users.sloth = {
    isNormalUser = true;
    shell = pkgs.bashInteractive;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    # No password is declared here on purpose, same as v10. mutableUsers
    # defaults to true, so whatever password you set with `passwd sloth`
    # (or already set on this machine) persists across rebuilds untouched.
    # A fresh install with no password set yet will not be able to sudo —
    # run `passwd sloth` once from a root/rescue shell before relying on
    # nix-apply/nix-sync, or those scripts' `sudo nixos-rebuild ...` calls
    # will just sit there rejecting empty input.
  };

  # Appliance-like tty1 autologin. Home Manager starts Sway without `exec`, so
  # an exit/crash always lands back at the shell instead of restart-looping.
  services.getty.autologinUser = "sloth";

  # Keep this at the version used when the machine was first installed —
  # matches v10; do not bump it just because nixpkgs tracks 26.05 now.
  system.stateVersion = "24.11";
}
