# Upgrade from v11.3.2

Keep `~/v11-test/v11_3_2` until v11.3.3 is working. It already contains the
real T440 `hardware-configuration.nix` and a working lock file.

From the new extracted directory:

```sh
cd ~/v11-test/v11_3_3
touch ~/.disable-gui
./prepare.sh
nix flake check
sudo nixos-rebuild test --flake .#thinkpad
rice-doctor
```

`prepare.sh` now checks `~/v11-test/v11_3_2` first, so no manual `cp` is needed.

If the checks pass, test Sway manually:

```sh
theme-sync --startup
sway
```

Only after the desktop, hardware keys, networking, audio, suspend/resume and
`Super+Shift+E` exit are all good:

```sh
nix-apply
rm -f ~/.disable-gui ~/.disable-sway ~/.disable-x
sudo reboot
```
