# Services vs. Subscriptions

## Problem Statement

You assign entitlements to your subaccount to access services and subscriptions. However, entitlements do not distinguish between services, app subscriptions, or runtimes. The Terraform provider for SAP BTP handles service instance creation and app subscriptions using different resources. Consequently, creating a generic configuration that uses service/app names and plan names for both entitlement and creation of service instances and app subscriptions is not straightforward.

## Solution Proposal

After assigning entitlements to the subaccount, all relevant type information is available in the entitlement's `category` attribute. You can then build a map of enriched entitlements with category information and group them by category into service, app, and runtime entitlements. These groups enable generic creation of service instances or app subscriptions.
