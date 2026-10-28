if (!(Get-Process whkd -ErrorAction SilentlyContinue))
{
    echo "whkd"
    Start-Process whkd -WindowStyle hidden
}

if (!(Get-Process python.exe -ErrorAction SilentlyContinue))
{
    echo "yasb"
    $process = {CD D:\Software\yasb\src && conda activate yasb && python main.py}
    Start-Process pwsh -WindowStyle hidden -ArgumentList "-c $process"
}

# . $PSScriptRoot\komorebi.generated.ps1

komorebic alt-focus-hack enable # Send the ALT key whenever changing focus to force focus changes
komorebic window-hiding-behaviour cloak # Default to cloaking windows when switching workspaces
komorebic cross-monitor-move-behaviour insert # Set cross-monitor move behaviour to insert instead of swap
komorebic watch-configuration enable # Enable hot reloading of changes to this file
komorebic mouse-follows-focus disable # not focus mouse

# Create named workspaces I-V on monitor 0
komorebic ensure-named-workspaces 1 I II III IV V
komorebic ensure-named-workspaces 0 Term Browser Code D E F
# komorebic ensure-named-workspaces 1 A B C D E F

# Assign layouts to workspaces, possible values: bsp, columns, rows, vertical-stack, horizontal-stack, ultrawide-vertical-stack
komorebic named-workspace-layout Term bsp
komorebic named-workspace-layout E ultrawide-vertical-stack

# Set the gaps around the edge of the screen for a workspace
komorebic named-workspace-padding Term 1
komorebic named-workspace-padding Browser 1
komorebic named-workspace-padding Code 1
komorebic named-workspace-padding D 1
komorebic named-workspace-padding E 1

komorebic named-workspace-padding I 1
komorebic named-workspace-padding II 1
komorebic named-workspace-padding III 1
komorebic named-workspace-padding IV 1
komorebic named-workspace-padding V 1
# Set the gaps between the containers for a workspace
komorebic named-workspace-container-padding Term 0
komorebic named-workspace-container-padding Browser 0
komorebic named-workspace-container-padding Code 0
komorebic named-workspace-container-padding D 0
komorebic named-workspace-container-padding E 0

komorebic named-workspace-container-padding I 1
komorebic named-workspace-container-padding II 1
komorebic named-workspace-container-padding III 1
komorebic named-workspace-container-padding IV 1
komorebic named-workspace-container-padding V 1

# You can assign specific apps to named workspaces
komorebic named-workspace-rule exe "WindowsTerminal.exe" Term
komorebic named-workspace-rule exe "firefox.exe" Browser
komorebic named-workspace-rule exe "Code.exe" Code

# Configure the invisible border dimensions
# komorebic invisible-borders 7 0 14 7
komorebic invisible-borders 1 0 2 1
# komorebic invisible-borders 0 0 0 0

# Uncomment the next lines if you want a visual border around the active window
komorebic active-window-border-colour 201 92 114 --window-kind single
komorebic active-window-border-colour 256 165 66 --window-kind stack
komorebic active-window-border-colour 156 101 174 --window-kind monocle
komorebic active-window-border-width 10
komorebic active-window-border-offset 0
komorebic active-window-border enable

komorebic complete-configuration
