#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$JQ_TRANSFORM_SERVICE = @'
{
    name: .name,
    displayName: .displayName,
    description: .description,
    servicePlans: [.servicePlans[] | {
        name: .name,
        displayName: .displayName,
        description: .description,
        uniqueIdentifier: .uniqueIdentifier,
        dataCenters: [.dataCenters[]? | {
            name: .name,
            displayName: .displayName,
            region: .region,
            iaasProvider: .iaasProvider
        }]
    }]
}
'@

function Test-Prerequisites {
    $missing = $false

    if (-not (Get-Command "btp" -ErrorAction SilentlyContinue)) {
        Write-Host "Error: 'btp' CLI is not installed or not in PATH."
        $missing = $true
    }

    if (-not (Get-Command "jq" -ErrorAction SilentlyContinue)) {
        Write-Host "Error: 'jq' is not installed or not in PATH."
        $missing = $true
    }

    if ($missing) {
        exit 1
    }
}

function Get-Entitlements {
    $rawJson = btp --format json list accounts/entitlement 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to fetch entitlements from BTP."
        Write-Host $rawJson
        exit 1
    }

    return $rawJson
}

Test-Prerequisites

Write-Host "What would you like to do?"
Write-Host "  1) Get an overview of all entitled services"
Write-Host "  2) Get details for a specific service"
$choice = Read-Host "Enter your choice (1 or 2)"

switch ($choice) {
    "1" {
        Write-Host "Fetching entitled services..."
        $rawJson = Get-Entitlements

        $jqFilter = "[.entitledServices[] | $JQ_TRANSFORM_SERVICE] | sort_by(.name)"
        $rawJson | jq $jqFilter | Out-File -FilePath "service-list.json" -Encoding utf8

        Write-Host "Done. Results written to service-list.json"
    }
    "2" {
        $serviceInput = Read-Host "Enter the service name"

        if ([string]::IsNullOrWhiteSpace($serviceInput)) {
            Write-Host "Error: No service name provided."
            exit 1
        }

        Write-Host "Fetching entitled services..."
        $rawJson = Get-Entitlements

        $inputLower = $serviceInput.ToLower()

        $jqFilter = '[.entitledServices[] | select((.name | ascii_downcase) == $input or (.displayName | ascii_downcase) == $input) | ' + $JQ_TRANSFORM_SERVICE + ']'
        $result = $rawJson | jq --arg input $inputLower $jqFilter

        $matchCount = ($result | jq 'length').Trim()

        if ($matchCount -eq "0") {
            Write-Host "Error: No service found matching '$serviceInput'."
            exit 1
        }

        $outputName = ($result | jq -r '.[0].name').Trim()
        $outputFile = "$outputName.json"
        $result | Out-File -FilePath $outputFile -Encoding utf8

        Write-Host "Done. Found $matchCount match(es). Results written to $outputFile"
    }
    default {
        Write-Host "Invalid choice. Please enter 1 or 2."
        exit 1
    }
}
