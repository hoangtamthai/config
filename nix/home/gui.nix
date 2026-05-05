{
  pkgs,
  unstable,
  inputs,
  ...
}:
{
  imports = [ ./home.nix ];

  home.packages = with pkgs; [
    copyq
    discord
    konsave
    # miktex
    texliveFull
    mpv-unwrapped
    obsidian
    # steam
    termius
    thunderbird
    ungoogled-chromium
    vlc
    wireguard-tools
    # vscode-runner
    # yaak
    unstable.firefox
    # unstable.rustdesk
    unstable.syncthingtray-minimal
    unstable.vscode
    # unstable.zed-editor

    inputs.ie-r.packages.${pkgs.system}.default
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
    # INPUT_METHOD = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
  home.file.".config/mpv/mpv.conf".text = ''
    # --- Video Quality & Performance ---
    profile=gpu-hq              # Uses high-quality shaders and scaling
    vo=x11                      # Uses the GPU for video output (essential)
    hwdec=auto-safe             # Enables hardware decoding (saves battery/CPU)

    # --- Subtitle Styling (Cleaner look) ---
    sub-font='sans-serif'       # Changes the font to something modern
    sub-font-size=45            # Adjust size to your preference
    sub-color='#FFFFFFFF'       # Pure white
    sub-border-size=2           # Thin black outline for readability
    sub-shadow-offset=1         # Subtle shadow
    sub-shadow-color='#33000000' # Semi-transparent shadow

    # --- Behavior & Interface ---
    hr-seek=yes
    demuxer-mkv-subtitle-preroll=yes
    save-position-on-quit=yes   # Remembers where you left off in a video
    volume-max=200              # Allows boosting volume up to 200%
    keep-open=yes               # Don't close the player when the video ends
    autofit-larger=90%x90%      # Don't let the window be larger than your screen
    force-seekable=yes
    stream-lavf-o=fflags=+fastseek
    watch-later-options=start,sid,aid

    # --- Network & Streaming ---
    cache=yes
    demuxer-max-bytes=150MiB
    demuxer-readahead-secs=10
    network-timeout=90
    # http-header-fields='User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'

    # 1. Disable the "fix timing" logic which often causes duplicates during seeks
    sub-fix-timing=no

    # 2. Force the subtitle renderer to clear its cache on every seek
    sub-clear-on-seek=yes

    # 3. Disable subtitle "preroll" (sometimes looking back causes it to grab old lines)
    demuxer-mkv-subtitle-preroll=no

    # 4. Use a more aggressive demuxer thread to handle packets faster
    demuxer-thread=yes

    # 5. Ensure subtitles don't stay on screen longer than they should
    sub-gauss=0.0
  '';
}
