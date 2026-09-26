# Buckit — releases

This repository only hosts **Buckit's release downloads**. It contains no source code.
Buckit's built-in updater checks the [latest release](../../releases/latest) here.

## Download

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
