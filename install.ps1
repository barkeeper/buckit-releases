# Installs the latest Buckit on this machine (per-user; no admin rights needed).
#   irm https://raw.githubusercontent.com/barkeeper/buckit-releases/main/install.ps1 | iex
# Downloads the newest MSI from this repo's latest release, verifies it against the release's
# checksums.txt, then installs it. Re-running it upgrades an existing install.
& {
    param([switch]$NoInstall)
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'   # much faster Invoke-WebRequest on Windows PowerShell 5.1
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $release = Invoke-RestMethod 'https://api.github.com/repos/barkeeper/buckit-releases/releases/latest' -Headers @{ 'User-Agent' = 'Buckit-Installer' }
    $msi  = $release.assets | Where-Object { $_.name -like '*.msi' } | Select-Object -First 1
    $sums = $release.assets | Where-Object { $_.name -eq 'checksums.txt' } | Select-Object -First 1
    if (-not $msi -or -not $sums) { throw "Release $($release.tag_name) has no MSI or checksums.txt" }

    $dir = Join-Path $env:TEMP 'Buckit-install'
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $file = Join-Path $dir $msi.name
    Write-Host "Downloading Buckit $($release.tag_name)..."
    Invoke-WebRequest $msi.browser_download_url -OutFile $file -UseBasicParsing

    $sumsFile = Join-Path $dir 'checksums.txt'
    Invoke-WebRequest $sums.browser_download_url -OutFile $sumsFile -UseBasicParsing
    $line = Get-Content $sumsFile | Where-Object { $_ -match ('\s\*?' + [regex]::Escape($msi.name) + '\s*$') } | Select-Object -First 1
    $expected = if ($line) { ($line -split '\s+')[0].ToLower() } else { $null }
    # .NET SHA-256 (Get-FileHash is missing on some Windows PowerShell 5.1 setups).
    $stream = [IO.File]::OpenRead($file)
    try { $actual = -join ([Security.Cryptography.SHA256]::Create().ComputeHash($stream) | ForEach-Object { $_.ToString('x2') }) }
    finally { $stream.Dispose() }
    if (-not $expected -or $actual -ne $expected) {
        Remove-Item $file -Force
        throw "Checksum mismatch for $($msi.name) - not installing."
    }
    Write-Host 'Checksum verified.'
    if ($NoInstall) { Write-Host "Verified download kept at $file"; return }

    Write-Host 'Installing...'
    $p = Start-Process msiexec.exe -ArgumentList '/i', "`"$file`"", '/passive', '/norestart' -Wait -PassThru
    Remove-Item $file -Force -ErrorAction SilentlyContinue
    if ($p.ExitCode -notin 0, 3010) { throw "msiexec failed with exit code $($p.ExitCode)" }
    Write-Host "Buckit $($release.tag_name) installed. Start it from the Start menu or desktop shortcut."
} @args
