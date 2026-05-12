for ($i = 0; $i -lt 15; $i++) {
    docker info > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Docker is running"
        exit 0
    }
    Write-Output "Waiting for Docker daemon to start... ($i/15)"
    Start-Sleep -Seconds 5
}
Write-Output "Docker failed to start within 75 seconds"
exit 1
