# Import-Module -Name Terminal-Icons
# Import-Module -Name PSReadLine
# Import-Module -Name z
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -Colors @{
    # Command = "`e[30;107m"
    # Comment = "`e[32;107m"
    # ContinuationPrompt = "`e[30;47m"
    Emphasis = "`e[93m" # yellow
    # Error = "`e[91;47m"
    # InlinePrediction = "`e[90;47m"
    # Keyword = "`e[92;47m"
    ListPrediction = "`e[90m" # gray
    ListPredictionSelected = "`e[48;5;238m"
    # Member = "`e[97;47m"
    # Number = "`e[30;47m"
    # Operator ="`e[90;47m"
    # Parameter = "`e[90;47m"
    # Selection = "`e[30;107m"
    # String = "`e[36;47m"
    # Type = "`e[30;47m"
    # Variable =  "`e[92;47m"
}
$PSStyle.FileInfo.Directory ="`e[91m"

.$env:USERPROFILE\"OneDrive - 360 Treasury Systems AG"\Documents\PowerShell\user_profile.ps1

oh-my-posh init pwsh --config C:\Users\TamHoang\tam\config\cli\ohmyposh\rose-quartz.json | Invoke-Expression
