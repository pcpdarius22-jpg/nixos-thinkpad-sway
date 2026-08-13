# v11.3.3 validation notes

Static checks completed before packaging:

- all shell scripts pass `bash -n`;
- generated qutebrowser Python compiles;
- generated Yazi TOML parses;
- generated Waybar multi-bar JSON parses with `jq`;
- wallpaper decodes and normalizes with ImageMagick;
- no lemonbar source/input/package remains;
- no pywal/wallpaper-derived palette logic remains;
- no Sway `default_border pixel` or colored focus-border path remains;
- no duplicate exact Sway key combinations were found by the local checker;
- archive integrity is tested after ZIP creation.

Hardware/runtime validation still belongs on the real T440. Required sequence:

```sh
./prepare.sh ~/v11-test/v11_2
nix flake check
sudo nixos-rebuild test --flake .#thinkpad
rice-doctor
```

Then launch `theme-sync --startup` and `sway` manually. Do not use `switch`
until PxPlus, the transparent edge text, qutebrowser, hardware keys, suspend,
Wi-Fi/Bluetooth and the clean Sway exit path all work.


## v11.3.3 hotfix
- Removed `swaynag` from `home.packages`. `swaynag` is provided by the Sway package itself; the `swaynag` command in the Sway exit binding is intentionally retained.

## v11.3.3 font-family correction

Real T440 validation showed that the Ultimate Oldschool PC Font Pack exposes the
wanted face as `PxPlus IBM VGA 8x16` (`PxPlus_IBM_VGA_8x16.ttf`), not
`PxPlus IBM VGA8`. v11.3.3 corrects that family name everywhere: NixOS and Home
Manager font defaults, Sway, Foot, qutebrowser, Fuzzel/Waybar-generated config,
and `rice-doctor`.

## v11.3.3 T440 font-scale polish

Validated on the actual 1600x900 T440 during the v11.3.2 test: 9pt was too
small and 11pt was slightly too large for the reference aesthetic. v11.3.3
uses PxPlus IBM VGA 8x16 at 10pt for the main UI (Foot/Sway/qutebrowser/
dunst/fuzzel/GTK) and 9px for the intentionally tiny transparent Waybar edge
text. Terminal TUI programs inherit Foot's 10pt font.
