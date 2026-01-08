let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

{
  all = pkgs.buildEnv {
    name = "tam";
    paths = with pkgs; [
      # Core CLI and version control
      git git-lfs gh
      
      # Search and navigation
      ripgrep fd fzf tmux just direnv
      
      # Editors
      neovim vscode
      
      # Language runtimes  
      python3 nodejs_20 go rustc cargo openjdk24 gcc bun
      
      # Build and containers
      docker docker-compose
      
      # Keyboard remapper
      kanata
    ];
  };
}

