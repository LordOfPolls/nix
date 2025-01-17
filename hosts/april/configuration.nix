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

  networking.hostName = "april";
  services.xserver.videoDrivers = ["nvidia"];
  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
}
