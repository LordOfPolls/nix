{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "polls";
  home.homeDirectory = "/home/polls";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.zoxide
    pkgs.fd
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "Vitals@CoreCoding.com"
        "clipboard-indicator@tudmotu.com"
        "quick-settings-tweaks@qwreey"
        "space-bar@luchrioh"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      extend-height = false;
      dock-fixed = false;
      autohide = true;
      intellihide = true;
      animation-time = 0.2;
      transparency-mode = "DYNAMIC";
      background-opacity = 0.8;
      show-apps-at-top = false;
      show-trash = false;
    };

    "org/gnome/shell/extensions/vitals" = {
      show-storage = true;
      show-temperature = true;
      show-voltage = false;
      show-memory = true;
      show-processor = true;
      show-network = true;
      position-in-panel = "right";
      hide-zeros = true;
      fixed-widths = true;
      update-time = 5;
    };

    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = true;
      show-notifications = true;
      restore-state = true;
      enable-fullscreen = true;
      toggle-state = false;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      history-size = 10;
      preview-size = 60;
      strip-text = true;
      clear-on-logout = true;
      enable-keybindings = true;
      clear-history = ["<Super>c"];
      toggle-menu = ["<Super>v"];
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      output-show-selected-only = true;
      volume-mixer-enabled = true;
      volume-mixer-position = "bottom";
      media-control-enabled = true;
      media-control-compact-mode = true;
      notifications-enabled = true;
      notifications-position = "bottom";
    };

    "org/gnome/shell/extensions/space-bar" = {
      position = "left";
      indicator-style = "workspaces-bar";
      show-empty-workspaces = true;
      workspaces-bar-mode = "name";
      workspace-margin = 4;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      os = {
        disabled = false;
        format = "[$symbol]($style) ";
        style = "bold white";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[](bold green)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
      };

      cmd_duration = {
        min_time = 10000;
        format = "[$duration]($style) ";
        style = "yellow";
      };

      hostname = {
        ssh_only = false;
      };

      rust = {
        format = "via [$symbol$version]($style) ";
        style = "bold red";
      };

      python = {
        format = "via [$symbol$version]($style) ";
        style = "bold yellow";
      };

      format = "$sudo$os$username$hostname$directory$git_branch$git_status$cmd_duration$rust$python$memory_usage$line_break$character";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      HISTSIZE=10000
      SAVEHIST=10000

      eval "$(zoxide init zsh)"
    '';
    shellAliases = {
      cat = "bat";

      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      l = "eza -l";
      tree = "eza --tree";

      dsize = "dust";
      dsorted = "dust -r";
      du = "dust";

      ssh = "kitten ssh";

      cd = "z";
      find = "fd";
    };
  };

  programs.kitty = {
    enable = true;
    theme = "Atom";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      window_padding_width = 4;
    };
  };

  programs.btop.settings = {
    color_theme = "./tokyo-night.theme";
    theme_background = true;
    rounded_corners = true;
  };

  programs.git = {
    enable = true;
    userName = "LordOfPolls";
    userEmail = "dev@lordofpolls.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
  };

  programs.gitui = {
    enable = true;
    theme = (import ./themes/gitui/mocha.nix).theme;
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
    };

    profiles.polls = {
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        youtube-shorts-block
      ];
      settings = {
        "browser.toolbars.bookmarks.visibility" = "always";
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
