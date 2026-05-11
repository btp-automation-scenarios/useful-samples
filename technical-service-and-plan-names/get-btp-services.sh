#!/usr/bin/env bash
set -euo pipefail

JQ_TRANSFORM_SERVICE='
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
'

check_prerequisites() {
    local missing=0

    if ! command -v btp &>/dev/null; then
        echo "Error: 'btp' CLI is not installed or not in PATH."
        missing=1
    fi

    if ! command -v jq &>/dev/null; then
        echo "Error: 'jq' is not installed or not in PATH."
        missing=1
    fi

    if [[ $missing -ne 0 ]]; then
        exit 1
    fi

    if btp 2>/dev/null | grep --silent "not logged in"; then
        echo "Please log in with the btp CLI (use btp login)."
        exit 1
    fi

}

fetch_entitlements() {
    local raw_json
    if ! raw_json=$(btp --format json list accounts/entitlement 2>&1); then
        echo "Error: Failed to fetch entitlements from BTP."
        echo "$raw_json"
        exit 1
    fi
    printf '%s' "$raw_json"
}

check_prerequisites

echo "What would you like to do?"
echo "  1) Get an overview of all entitled services"
echo "  2) Get details for a specific service"
read -r -p "Enter your choice (1 or 2): " choice

case "$choice" in
    1)
        echo "Fetching entitled services..."
        raw_json=$(fetch_entitlements)

        printf '%s' "$raw_json" | jq '
            [.entitledServices[] | '"$JQ_TRANSFORM_SERVICE"'] | sort_by(.name)
        ' > service-list.json

        echo "Done. Results written to service-list.json"
        ;;
    2)
        read -r -p "Enter the service name: " service_input

        if [[ -z "$service_input" ]]; then
            echo "Error: No service name provided."
            exit 1
        fi

        echo "Fetching entitled services..."
        raw_json=$(fetch_entitlements)

        input_lower=$(printf '%s' "$service_input" | tr '[:upper:]' '[:lower:]')

        result=$(printf '%s' "$raw_json" | jq --arg input "$input_lower" '
            [.entitledServices[] |
                select((.name | ascii_downcase) == $input or (.displayName | ascii_downcase) == $input) |
                '"$JQ_TRANSFORM_SERVICE"'
            ]
        ')

        match_count=$(printf '%s' "$result" | jq 'length')

        if [[ "$match_count" -eq 0 ]]; then
            echo "Error: No service found matching '$service_input'."
            exit 1
        fi

        # Use the technical service name for the output filename
        output_name=$(printf '%s' "$result" | jq -r '.[0].name')
        output_file="${output_name}.json"
        printf '%s\n' "$result" > "$output_file"

        echo "Done. Found $match_count match(es). Results written to $output_file"
        ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        exit 1
        ;;
esac
