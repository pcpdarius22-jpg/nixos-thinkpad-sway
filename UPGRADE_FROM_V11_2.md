# Moving from the current v11.2 test to v11.3.3

You do not need to delete v11.2 and you do not need to manually `cp` the
hardware file.

Keep both ZIPs in GitHub for now. On the T440, pull the repo containing the new
ZIP, extract v11.3.3 into `~/v11-test`, and run:

```sh
cd ~/v11-test/v11_3_3
touch ~/.disable-gui
./prepare.sh ~/v11-test/v11_3
```

That copies the **real** `system/hardware-configuration.nix` and the current
`flake.lock` from the already-prepared v11.2 folder, then reconciles the lock to
v11.3.3's inputs.

Continue with:

```sh
nix flake check
sudo nixos-rebuild test --flake .#thinkpad
rice-doctor
```

Do not run `switch` until the Sway test looks and behaves correctly.
