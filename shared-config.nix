{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.baobab # disk usage analyzer
    pkgs.cheese # photo booth
    pkgs.eog # image viewer
    pkgs.epiphany # web browser
    pkgs.gedit # text editor
    pkgs.simple-scan # document scanner
    pkgs.totem # video player
    pkgs.yelp # help viewer
    pkgs.evince # document viewer
    pkgs.file-roller # archive manager
    pkgs.geary # email client
    pkgs.seahorse # password manager

    # these should be self explanatory
    pkgs.gnome-calculator
    pkgs.gnome-calendar
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-weather
    pkgs.gnome-connections
    pkgs.gnome-terminal
    pkgs.gnome-console
  ];
  services.xserver.excludePackages = [pkgs.xterm];

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #environment.plasma6.excludePackages = with pkgs.libsForQt5; [
  #  konsole
  #  gwenview
  #  okular
  #  elisa
  #];

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.polls = {
    isNormalUser = true;
    description = "polls";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      pkgs.jetbrains.pycharm-professional
      pkgs.jetbrains.rust-rover
      pkgs.jetbrains.rider
      pkgs.vlc
      pkgs.obsidian
      pkgs.discord
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "polls" = import ./home.nix;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    pkgs.nixfmt-rfc-style
    git
    kitty
    pkgs.nixfmt-rfc-style
    firefox
    pkgs.rustup
    pkgs.pyenv
    pkgs.vscode
    alejandra
  ];

  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerdfonts
  ];

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  services.openssh.enable = true;

  system.stateVersion = "24.11";
}
