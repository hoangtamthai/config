{ pkgs, unstable, ... }:
{
  imports = [ ./home.nix ];

  home.packages = with pkgs; [
    discord
    unstable.firefox
    obsidian
    steam
    syncthingtray
    termius
    thunderbird
    ungoogled-chromium
    unstable.vscode
    vscode-runner
    # unstable.zed-editor
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs.kdePackages; [
      fcitx5-unikey
    ];
  };

  home.sessionVariables = {
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
  };

}
