# Alias
Set-Alias ll ls
Set-Alias grep findstr
Set-Alias g git
Set-Alias touch New-Item
Set-Alias which where.exe
function ln ($target, $link) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target
}
# function sudo ($command) {
#     Start-Process pwsh "-noe -c $command" -Verb Runas
# }
function rename ($target, $link) {
    Rename-Item $target $link
}
function time {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$command,
        [switch]$quiet = $false
    )
    $start = Get-Date
    try {
        if ( -not $quiet ) {
            iex $command | Write-Host
        } else {
            iex $command > $null
        }
    } finally {
        $(Get-Date) - $start
    }
}
