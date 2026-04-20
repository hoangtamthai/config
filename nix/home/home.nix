{ pkgs, unstable, ... }:
{
  home.username = "tam";
  home.homeDirectory = "/home/tam";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true; # add path
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # shells
    direnv
    eza
    fd
    fzf
    git
    git-lfs
    just
    ripgrep
    screen
    tmux
    z-lua
    # tools
    kanata
    ffmpeg
    oh-my-posh
    imagemagick
    tailscale
    # editors
    neovim
    # dev tools
    docker
    docker-compose
    opencode
    unstable.pnpm
    sqlite

    # languages
    python3
    openjdk25
    nodejs_24
    bun
    lua
    gcc
    go
    rustc
    cargo

    # nix
    nix
    nil
    nixfmt

    # fonts
    nerd-fonts.roboto-mono
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Tam Thai";
      email = "tamthai.de@gmail.com";
    };
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      la = "eza -la";
      ls = "eza";
      g = "git";
      hms = "home-manager switch --flake ~/config/nix/.#tam-gui";
    };
    loginExtra = ''
      if [ -d "$HOME/.nix-profile/bin" ] ; then
        PATH="$HOME/.nix-profile/bin:$PATH"
      fi

      if [ -d "$HOME/.nix-profile/share/applications" ] ; then
        PATH="$HOME/.nix-profile/share/applications:$PATH"
      fi

      # Start Kanata in the background if it's not already running
      if ! pgrep -x "kanata" > /dev/null; then
        ${pkgs.kanata}/bin/kanata --cfg $HOME/config/kanata/config.kbd > /tmp/kanata.log 2>&1 &
      fi

      # Set XDG_DATA_DIRS for GUI applications
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:/usr/local/share:/usr/share"

      # Set locale
      export LANG=en_US.UTF-8
      export LANGUAGE=en_US
    '';
    initContent = ''
      # ohmypost init
      eval "$(oh-my-posh init zsh --config ~/config/ohmyposh/rose-quartz.json)"
    '';
  };
  programs.z-lua = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "enhanced"
      "once"
      "fzf"
    ];
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
