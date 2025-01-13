{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../shared-config.nix
  ];

  networking.hostName = "demi";
  services.xserver.libinput.enable = true;
}
