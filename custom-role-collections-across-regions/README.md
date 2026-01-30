# Custom Role Collections across regions

## Problem Statement

When creating custom role collections in different subaccounts (regions), role templates require a region-specific `app_id`. To maintain generic code that works across all regions, you must dynamically fetch the correct `app_id` for each role template based on the subaccount's region.

## Solution Proposal

This module fetches all roles in the target subaccount and maps role names to their corresponding `app_id`s. It takes base role collections (without `app_id`s) as input and produces enhanced role collections with the correct `app_id`s for each role template.

To handle cases where no role is found or multiple `app_id`s are found for a role name and role template name combination:

- Ensure only one result is returned using the Terraform function `one()`
- Add a precondition in the module output to validate all roles have valid `app_id`s
