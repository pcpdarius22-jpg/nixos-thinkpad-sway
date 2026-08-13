{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Exact reference-rice stack
    foot
    qutebrowser
    dunst
    senpai
    waybar
    fuzzel
    imagemagick
    ultimate-oldschool-pc-font-pack
    wireplumber
    pipewire
    libnotify
    blueman

    # Wayland/Sway utilities
    swayidle
    swaylock
    grim
    slurp
    wl-clipboard
    brightnessctl
    playerctl

    # Terminal-first daily tools
    yazi
    btop
    fastfetch
    cmus
    fzf
    fd
    ripgrep
    zoxide
    jq
    gawk
    fontconfig
    lazygit
    lynx
    pulsemixer
    socat
    procps
    python3

    # Lightweight viewers / media
    imv
    zathura
    yt-dlp
    sox

    # Music production / compatibility retained from the working v10
    reaper
    wineWow64Packages.stable
    winetricks

    # Games — deliberately not retroarchFull, avoiding huge optional cores.
    retroarch

    # Torrents: daemon is started by the helper only while tremc is in use.
    transmission_4
    tremc
  ];

  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = false;
    keyBindings.normal = {
      "d" = "tab-close";
      "u" = "undo";
      ",m" = "spawn mpv {url}";
      ",y" = "spawn yt-dlp {url}";
    };
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      aw = "https://wiki.archlinux.org/?search={}";
    };
    settings = {
      # Settings recovered verbatim from the reference author's Reddit reply.
      tabs.position = "right";
      tabs.width = 30;
      tabs.title.alignment = "center";
      tabs.favicons.show = "never";
      tabs.indicator.width = 0;
      tabs.title.format = "{index}";
      tabs.show = "multiple";

      statusbar.show = "in-mode";
      statusbar.position = "bottom";

      fonts.default_family = "PxPlus IBM VGA 8x16";
      fonts.default_size = "10pt";
      fonts.statusbar = "10pt PxPlus IBM VGA 8x16";
      fonts.tabs.selected = "10pt PxPlus IBM VGA 8x16";
      fonts.tabs.unselected = "10pt PxPlus IBM VGA 8x16";
      fonts.completion.entry = "10pt PxPlus IBM VGA 8x16";
      fonts.completion.category = "bold 10pt PxPlus IBM VGA 8x16";

      content.javascript.enabled = true;
      content.blocking.enabled = true;
      content.blocking.method = "auto";
      content.notifications.presenter = "libnotify";
      colors.webpage.darkmode.enabled = true;
      colors.webpage.darkmode.policy.images = "never";
      colors.webpage.preferred_color_scheme = "dark";
      scrolling.bar = "never";
      hints.radius = 0;
      tabs.tooltips = false;
      window.hide_decoration = true;
      url.start_pages = [ "about:blank" ];
      url.default_page = "about:blank";

      editor.command = [ "rice-foot" "-a" "qute-editor" "nvim" "+call cursor({line}, {column})" "{file}" ];
    };
    extraConfig = ''
      c.tabs.padding = {
          'top': 4,
          'bottom': 4,
          'left': 8,
          'right': 6,
      }
      c.statusbar.padding = {
          'top': 5,
          'bottom': 5,
          'left': 8,
          'right': 8,
      }

      import os
      _rice_theme = os.path.expanduser('~/.config/rice/generated/qute-colors.py')
      if os.path.isfile(_rice_theme):
          config.source(_rice_theme)
      _rice_web = os.path.expanduser('~/.config/rice/generated/web.css')
      if os.path.isfile(_rice_web):
          c.content.user_stylesheets = [_rice_web]
    '';
  };

  # Mutable config is intentional: activation writes a fixed monochrome Dunst
  # config, independent of the wallpaper.
  services.dunst = {
    enable = true;
    configFile = "/home/sloth/.config/rice/generated/dunstrc";
  };

  # These TUIs inherit the fixed monochrome Foot palette.
  home.file.".config/btop/btop.conf".text = ''
    color_theme = "TTY"
    theme_background = true
    truecolor = false
    rounded_corners = false
    vim_keys = true
    shown_boxes = "cpu mem proc"
    update_ms = 2000
    show_battery = false
  '';

  home.file.".config/cmus/rc".text = ''
    set color_win_bg=default
    set color_win_fg=default
    set color_win_cur=white
    set color_win_sel_bg=white
    set color_win_sel_fg=black
    set color_win_cur_sel_bg=white
    set color_win_cur_sel_fg=black
    set color_titleline_bg=default
    set color_titleline_fg=white
    set color_statusline_bg=default
    set color_statusline_fg=white
    set color_separator=white
    set set_term_title=true
    set format_title=cmus  %a - %t
  '';
}
