param (
    [string]$ManifestPath = ".\bucket\idasen-desk.json"
)

function Test-ScoopManifest {
    Write-Host "🔍 Loading manifest: $ManifestPath"

    if (-not (Test-Path $ManifestPath)) {
        Write-Error "❌ Manifest file not found."
        return
    }

    $manifest = Get-Content $ManifestPath | ConvertFrom-Json
    $url = $manifest.architecture.'64bit'.url
    $hash = $manifest.architecture.'64bit'.hash
    Write-Host "🌐 Testing download URL: $url"

    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
        if ($response.StatusCode -ne 200) {
            throw "URL returned status code $($response.StatusCode)"
        }
        Write-Host "✅ URL is accessible."
    } catch {
        Write-Error "❌ URL check failed: $_"
        return
    }

    $fileName = [System.IO.Path]::GetFileName($url)
    $fileExt = [System.IO.Path]::GetExtension($fileName)
    $tempFile = Join-Path $env:TEMP ("$($manifest.version)-test$fileExt")
    Write-Host "📥 Downloading file to $tempFile..."
    Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing

    Write-Host "🔐 Verifying SHA256 hash..."
    $actualHash = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash.ToLower()
    $expectedHash = $hash -replace "^sha256:", ""

    if ($actualHash -ne $expectedHash.ToLower()) {
        Write-Error "❌ Hash mismatch! Expected: $expectedHash, Got: $actualHash"
        return
    } else {
        Write-Host "✅ Hash matches."
    }

    $binaryName = $manifest.bin
    if ($fileExt -eq ".zip") {
        $extractPath = "$env:TEMP\scoop-test-extract"
        Write-Host "📦 Extracting archive to $extractPath..."
        Expand-Archive -Path $tempFile -DestinationPath $extractPath -Force

        $binaryPath = Join-Path $extractPath $binaryName
    } else {
        $binaryPath = $tempFile
    }

    if (Test-Path $binaryPath) {
        Write-Host "✅ Binary found: $binaryPath"
    } else {
        Write-Error "❌ Binary not found at expected path: $binaryPath"
        return
    }

    Write-Host "🎉 Manifest passed all checks!"
}

Test-ScoopManifest
