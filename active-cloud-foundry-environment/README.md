# Determine active Cloud Foundry Environment per region

## Problem Statement

The active Cloud Foundry environment differs depending on the subaccount region, especially in heavily used regions that host **extension landscapes**.

To anticipate the correct Cloud Foundry environment in your Terraform code, you need to determine the active Cloud Foundry environment per region, accounting for one or more extension landscapes.

## Solution Proposal

To determine the active Cloud Foundry environment per region, use the following approach:

- Fetch all Cloud Foundry environments available in the subaccount using the data source `btp_subaccount_environments`
- Determine the landscape label by filtering the environment data using the following attributes:
    - `service_name` must be `cloudfoundry`
    - `environment_type` must be `cloudfoundry`
    - `availability_level` must be `ACTIVE`

Store this information using the Terraform resource `terraform_data`.

## Restrictions

- The landscape label representing the active Cloud Foundry extension landscape can change over time. Consider fetching and storing this information statically rather than fetching it dynamically on every run. The proposed code may drift over time.
- You cannot actively influence which Cloud Foundry environment is used in your subaccount. If you specify a landscape label that belongs to an inactive extension landscape, the platform will place the environment in the active extension landscape, causing a mismatch between plan and state.
