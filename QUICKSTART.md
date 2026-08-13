# v11.3.3 quick start — T440

Do **not** delete your working v11.3.2 folder yet. It contains the real hardware
configuration copied from this T440, so v11.3.3 can reuse it automatically.

From the extracted `v11_3_3` directory:

```sh
touch ~/.disable-gui
./prepare.sh
nix flake check
sudo nixos-rebuild test --flake .#thinkpad
rice-doctor
```

If all of that succeeds, exit the current desktop to tty1 and start the test:

```sh
theme-sync --startup
sway
```

Inside Sway:

- `Super+Enter` — terminal
- `Super+B` — qutebrowser
- `Super+Shift+R` — reference screenshot layout
- `Super+W` — wallpaper picker; wallpaper changes do **not** change app colors
- `Super+Shift+E` — exit safely to tty1

The intended appearance is: full-color wallpaper; frameless black application
rectangles; white/gray text; no colored focus outline; no conventional panel.
The top-left clock and bottom-right status are native Wayland transparent text.

Only after the manual test is good:

```sh
nix-apply
rm -f ~/.disable-gui ~/.disable-sway ~/.disable-x
sudo reboot
```

After v11.3.3 is confirmed working, you can delete the old v11.3.2/v11.2 test folders if you want.
