# GitHub Copilot Instructions for Scoop Bucket

## Repository Overview

This is a custom [Scoop](https://scoop.sh) bucket repository for Windows command-line package installations. Scoop is a Windows package manager that installs programs from the command line. This bucket provides additional packages not available in the main Scoop buckets.

**Current Packages:**
- `idasen-systemtray`: System tray utility for controlling the Ikea Idasen desk via BluetoothLE on Windows 10/11

## Key Concepts

### Scoop Manifests
Package definitions are JSON files located in the `bucket/` directory. Each manifest describes:
- Package version, description, homepage, and license
- Download URLs and SHA256 hashes for different architectures
- Binary files and shortcuts
- Installation and uninstallation scripts
- Auto-update configuration using `checkver` and `autoupdate` fields

### Manifest Structure
```json
{
    "version": "1.0.0",
    "description": "Package description",
    "homepage": "https://example.com",
    "license": "MIT",
    "architecture": {
        "64bit": {
            "url": "https://example.com/download.exe",
            "hash": "sha256:..."
        }
    },
    "bin": ["executable.exe", "alias"],
    "shortcuts": [["executable.exe", "App Name"]],
    "checkver": { "github": "https://github.com/org/repo" },
    "autoupdate": { ... }
}
```

## Development Setup

### Prerequisites
- **PowerShell 5.1+** or **PowerShell Core 7+**
- **Scoop** installed on Windows
- **Pester** testing framework (automatically installed via CI)

### Local Testing
1. Test manifests using the validation script:
   ```powershell
   .\validate.ps1 -ManifestPath ".\bucket\<package-name>.json"
   ```

2. Run Pester tests:
   ```powershell
   $env:SCOOP_HOME = "path\to\scoop"
   .\bin\test.ps1
   ```

## Coding Conventions

### JSON Manifests
- Use 4-space indentation
- Include all required fields: version, description, homepage, license
- Always provide SHA256 hashes for downloads
- Use lowercase for hash values
- Include `checkver` and `autoupdate` for automatic version updates

### PowerShell Scripts
- Follow PowerShell best practices
- Use proper error handling with try/catch blocks
- Include descriptive Write-Host messages for logging
- Use CmdletBinding and proper parameter definitions

### File Organization
- Package manifests: `bucket/*.json`
- Deprecated packages: `deprecated/*.json`
- Test scripts: `bin/*.ps1`
- Validation script: `validate.ps1`

## Testing

### Test Structure
The repository uses Scoop's built-in test framework:
- Main test file: `Scoop-Bucket.Tests.ps1`
- Test runner: `bin/test.ps1`
- Tests run via Pester framework

### Running Tests Locally
```powershell
# Set SCOOP_HOME to your Scoop installation
$env:SCOOP_HOME = "C:\Users\YourName\scoop\apps\scoop\current"

# Run tests
.\bin\test.ps1
```

### CI/CD Testing
- Tests run automatically on push and pull requests
- Two test jobs: WindowsPowerShell and PowerShell Core
- Tests validate manifest syntax, URLs, and hashes

## Build & Deploy

### Automated Workflows

1. **CI Tests** (`.github/workflows/ci.yml`)
   - Runs on: push to main/master, pull requests
   - Tests manifests with both PowerShell versions

2. **Excavator** (`.github/workflows/excavator.yml`)
   - Automated version checking and updates
   - Runs on schedule
   - Creates PRs for package updates

3. **Manual Check Version** (`.github/workflows/checkver-manual.yml`)
   - Manually triggered workflow
   - Checks for package updates

### Useful Scripts
- `bin/checkver.ps1`: Check for new versions
- `bin/checkhashes.ps1`: Verify download hashes
- `bin/checkurls.ps1`: Validate download URLs
- `bin/formatjson.ps1`: Format JSON manifests
- `bin/auto-pr.ps1`: Create automated PRs for updates

## Architecture & Design Patterns

### Package Update Flow
1. Excavator or manual workflow checks for new versions using `checkver`
2. If new version found, `autoupdate` template generates new manifest
3. Hash is automatically calculated for new download
4. PR is created with updated manifest
5. CI tests validate the updated manifest

### Best Practices
- Always test manifests before committing
- Verify download URLs and hashes
- Include meaningful package descriptions
- Add installation notes if configuration is needed
- Use shortcuts for GUI applications
- Use bin for command-line tools

## Common Tasks

### Adding a New Package
1. Create `bucket/<package-name>.json`
2. Define all required fields
3. Test the manifest: `.\validate.ps1 -ManifestPath ".\bucket\<package-name>.json"`
4. Add checkver and autoupdate configuration
5. Run tests: `.\bin\test.ps1`
6. Submit PR

### Updating a Package
1. Modify version in manifest
2. Update download URLs
3. Calculate new SHA256 hash
4. Update bin/shortcuts if filenames changed
5. Test and submit PR

### Deprecating a Package
1. Move manifest from `bucket/` to `deprecated/`
2. Add deprecation reason in package notes
3. Submit PR

## Repository Structure
```
.github/
  workflows/          # GitHub Actions workflows
  ISSUE_TEMPLATE/     # Issue templates
bucket/               # Active package manifests
deprecated/           # Deprecated package manifests
bin/                  # Utility scripts
scripts/              # Additional scripts
validate.ps1          # Manifest validation script
Scoop-Bucket.Tests.ps1 # Pester tests entry point
```

## Additional Notes

- This is a Windows-specific package manager
- All packages should be tested on Windows 10/11
- Hash mismatches indicate file changes and require investigation
- Package names should be lowercase with hyphens
- Always include license information
