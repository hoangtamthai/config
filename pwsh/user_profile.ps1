Set-Alias ls li
Set-Alias grep rg
Set-Alias g git
Set-Alias touch New-Item
Set-Alias which where.exe

function li {eza -A -G --icons --group-directories-first}
function la {eza -lah --icons --group-directories-first}
function ll {eza -l --icons --group-directories-first}

function ln ($target, $link) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target
}

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

function y {
    $tmp = (New-TemporaryFile).FullName
    yazi.exe $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}