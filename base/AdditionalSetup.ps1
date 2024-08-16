$scripts = @(
                        (Join-Path $PSScriptRoot "AdditionalSetupArtifacts.ps1"),
                        (Join-Path $PSScriptRoot "AdditionalSetupSSH.ps1"),
                        (Join-Path $PSScriptRoot "AdditionalSetupDuplicateUsers.ps1")
)

Write-Host "Start AdditionalSetup"

if (!$TenantId) { $TenantId = "default" }
$serverInstanceState = (Get-NAVServerInstance BC).State
if ($serverInstanceState -ne "Running") {
    Write-Error "NAV ServerInstance not running, skipping AdditionalSetup..."
    return
}
$TenantState = (Get-NavTenant -ServerInstance BC -Tenant $TenantId).State
if ($TenantState -ne "Mounted" -and $TenantState -ne "Operational") {
    Write-Error "Tenant not mounted/operational, skipping AdditionalSetup..."
    return
}

foreach ($script in $scripts) {
    if (Test-Path -Path $script) {
        Write-Host "Execute $script"
        . ($script)
    }
}