{ ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # Stable low-latency default for the i5-4300U; 128 can be selected inside
    # a DAW when needed without making the whole desktop run at that quantum.
    extraConfig.pipewire."92-t440" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 1024;
      };
    };
  };

  security.pam.loginLimits = [
    { domain = "@audio"; type = "-"; item = "rtprio"; value = "95"; }
    { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
  ];
}
