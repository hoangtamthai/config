{
  pkgs,
  unstable,
  inputs,
  ...
}:
let
  agents = inputs.llm-agents.packages.${pkgs.system};
in
{
  home = {
    username = "tam";
    homeDirectory = "/home/tam";
    stateVersion = "25.11";
    packages = with pkgs; [
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
      zsh-autocomplete
      # tools
      kanata
      fastfetch
      ffmpeg
      oh-my-posh
      imagemagick
      rclone
      tailscale
      tailscale-systray
      unstable.syncthing
      # editors
      neovim
      # dev tools
      cmake
      clang
      docker
      docker-compose
      libclang
      lazydocker
      hurl
      agents.opencode
      agents.pi
      unstable.pnpm
      sqlite

      # languages
      python3
      unstable.python314Packages.pip
      openjdk25
      nodejs_24
      bun
      lua
      # gcc
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
  };
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      settings.user = {
        name = "Tam Thai";
        email = "tamthai.de@gmail.com";
      };
    };
    z-lua = {
      enable = true;
      enableBashIntegration = true;
      options = [
        "enhanced"
        "once"
        "fzf"
      ];
    };
    zsh = {
      enable = true;
      autosuggestion.enable = false;
      enableCompletion = false;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      shellAliases = {
        la = "eza -la";
        ls = "eza";
        g = "git";
        hms = "home-manager switch --flake ~/config/nix/.#tam-gui";
        ncg = "nix-collect-garbage -d";
        vi = "nvim";
      };
      loginExtra = ''
        if [ -d "$HOME/.nix-profile/bin" ] ; then PATH="$HOME/.nix-profile/bin:$PATH"
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
        export NIX_PROFILE="$HOME/.nix-profile"

        # Set locale
        export LANG=en_US.UTF-8
        export LANGUAGE=en_US
      '';
      initContent = ''
        export LIBCLANG_PATH="${pkgs.libclang.lib}/lib"
        # options
        HISTFILE=~/.zsh_history
        HISTSIZE=10000
        SAVEHIST=10000
        setopt HIST_EXPIRE_DUPS_FIRST
        setopt EXTENDED_HISTORY
        setopt INC_APPEND_HISTORY      # Append immediately (key!)
        setopt SHARE_HISTORY           # Share across tabs/sessions
        setopt HIST_FIND_NO_DUPS

        # ohmyposh init
        eval "$(oh-my-posh init zsh --config ~/config/ohmyposh/rose-quartz.json)"

        # https://github.com/marlonrichert/zsh-autocomplete?tab=readme-ov-file#make--and--always-move-the-cursor-on-the-command-line
        # zsh-autocomplete
        autoload -Uz compinit
        compinit
        source $NIX_PROFILE/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
        zstyle ':completion:*' completer _expand _complete _ignored _approximate _expand_alias
        zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
        zstyle ':autocomplete:*' default-context history-incremental-search-backward 
        zstyle ':autocomplete:*' min-input 1
        zstyle ':autocomplete:*' add-semicolon no
        # menu selection
        bindkey -M menuselect '\r' .accept-line
        bindkey               '^I' expand-or-complete 
        bindkey -M menuselect '^I' menu-complete
        bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
        bindkey -M menuselect '^[[C' .forward-char  '^[OC' .forward-char
      '';
    };
  };

  services = {
    copyq.enable = true;
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
