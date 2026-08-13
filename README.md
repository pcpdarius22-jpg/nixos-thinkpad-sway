# ThinkPad T440 — Sway monochrome reference rice v11.3.3

NixOS 26.05 configuration for the ThinkPad T440 (i5-4300U, Intel HD 4400,
4 GB RAM) built around the unixporn reference workflow.

## Visual target

- The wallpaper stays **full-color** and acts as the painting/canvas.
- Applications are fixed **black / white / gray**. Wallpaper changes never
  recolor the UI.
- Sway has **no visible window border**, no colored focus outline, no titlebar
  bezel, no rounded corners and no decorative shadows.
- Windows are small intentional black content rectangles floating on the image.
- No normal desktop bar. The only persistent UI is tiny top-left date/time and
  bottom-right workspace/battery/RAM text rendered by native Wayland Waybar
  layers with transparent backgrounds, `exclusive=false`, and input passthrough.
- PxPlus IBM VGA 8x16 is installed in both the NixOS font set and Home Manager
  profile so the per-user fontconfig can find it reliably during a test rebuild.
- T440-tuned font scale: 10pt for normal application/UI text and 9px for the
  deliberately tiny transparent edge status text.

## Main stack

Sway, Foot, qutebrowser, Neovim, Yazi, btop, cmus, senpai, dunst, fuzzel,
Waybar (transparent edge text only), mpv, zathura, NetworkManager, BlueZ/Blueman,
PipeWire/WirePlumber, TLP, thermald and zram.

The bundled reference wallpaper is `user/wallpaper/773.jpg`.

## v11.3.3 fixes over v11.2

- removes lemonbar/XWayland edge overlays after the real T440 test showed their
  geometry expanding to full screen under Sway;
- replaces them with native Wayland transparent edge text;
- installs `ultimate-oldschool-pc-font-pack` into the Home Manager profile as
  well as NixOS system fonts and sets PxPlus IBM VGA 8x16 as the default family;
- changes Foot to the current `[colors-dark]` section and removes dynamic
  per-window color overrides;
- removes pywal and all wallpaper-derived app colors;
- converts Foot, qutebrowser, Neovim, Dunst, Fuzzel, Zathura, Yazi, cmus,
  btop/TTY ANSI colors, GTK selections and browser page rendering to monochrome;
- changes Sway to `default_border none` / `default_floating_border none`;
- removes the redundant second floating-toggle keybind;
- removes the unnecessary `pw-jack` dependency from the REAPER helper because
  PipeWire JACK replacement is already enabled at the NixOS level;
- seeds the bundled reference wallpaper once when v11.3.3 is first activated,
  then preserves later wallpaper choices.

## Safe migration

`system/hardware-configuration.nix` in the archive is intentionally a safety
placeholder. On your current T440 you already prepared v11.2, so the simplest
migration is:

```sh
cd ~/v11-test/v11_3_3
touch ~/.disable-gui
./prepare.sh ~/v11-test/v11_3
nix flake check
sudo nixos-rebuild test --flake .#thinkpad
rice-doctor
```

Then manually launch Sway from tty1:

```sh
theme-sync --startup
sway
```

Only after testing use:

```sh
nix-apply
rm -f ~/.disable-gui ~/.disable-sway ~/.disable-x
sudo reboot
```

See `QUICKSTART.md` and `UPGRADE_FROM_V11_2.md`.

## Wallpaper workflow

Changing the wallpaper does not rebuild NixOS and does not recolor apps:

```sh
set-wallpaper ~/Pictures/something.jpg
```

or `Super+W` for the picker. Restore the bundled image with:

```sh
theme-sync --reset-reference
```

## Important keys

| Key | Action |
|---|---|
| `Super+Enter` | Foot terminal |
| `Super+D` | Fuzzel launcher |
| `Super+B` | qutebrowser |
| `Super+E` | Neovim |
| `Super+Y` | Yazi |
| `Super+X` | btop |
| `Super+M` | cmus |
| `Super+I` | senpai |
| `Super+W` | wallpaper picker |
| `Super+Shift+R` | recreate reference layout |
| `Super+Space` | floating/tiled toggle |
| `Super+C` | center current window |
| `Super+Shift+H/J/K/L` | move floating window |
| `Super+Ctrl+H/J/K/L` | resize |
| `Super+Escape` | lock |
| `Super+Shift+E` | exit Sway safely |

## T440 choices retained

- Intel Haswell / HD 4400 with i965 VA-API and 32-bit graphics support;
- 50% zram plus the T440's real hardware-declared disk swap; no extra hardcoded
  swapfile;
- TLP, thermald and SSD TRIM;
- tap-to-click, TrackPoint, brightness and media keys;
- PipeWire default quantum 256 with helpers for 128-frame production use;
- BAT0/BAT1 charge thresholds;
- weekly old-generation/store cleanup;
- safe tty1 launch that returns to the shell if Sway exits instead of looping.
