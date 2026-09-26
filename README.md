# Buckit — releases

This repository only hosts **Buckit's release downloads**. It contains none of the app's source code, just
this README and a small install script.
Buckit's built-in updater checks the [latest release](../../releases/latest) here.

## Install

Paste **one** of these commands into a terminal and press Enter. It downloads the latest release,
checks it against `checksums.txt`, and installs Buckit for the current user. No admin rights are
needed. Running it again upgrades an existing install.

**PowerShell**

```powershell
irm https://buckit.struis.nl | iex
```

**Command Prompt (cmd)**

```cmd
powershell -c "irm https://buckit.struis.nl | iex"
```

You can read the script first: [`install.ps1`](install.ps1). `buckit.struis.nl` just redirects to it (the
full URL `https://raw.githubusercontent.com/barkeeper/buckit-releases/main/install.ps1` works too).

## Manual download

Get the newest version from **[Releases → Latest](../../releases/latest)**:

| File | What it is |
|---|---|
| `Buckit-<version>.msi` | Per-user Windows installer. Upgrades an existing install in place. |
| `Buckit-<version>-portable.exe` | Single-file portable version. Nothing to install. |
| `checksums.txt` | SHA-256 checksums of the files above. |

## Updating

Buckit checks for a newer version on startup (you can turn this off in Settings → General) and
from the tray via **Check for updates**. Before running a download, Buckit checks it against that
release's `checksums.txt` and refuses to install it if it doesn't match.

To verify a download yourself (PowerShell):

```powershell
Get-FileHash .\Buckit-<version>.msi -Algorithm SHA256
```

Compare the result with the matching line in `checksums.txt`.

## Requirements

Windows 10 or 11 (64-bit). The Java runtime is bundled, so there is nothing else to install.
