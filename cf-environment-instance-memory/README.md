# Dependencies between Cloud Foundry and MEMORY Entitlement

## Problem Statement

When creating an environment instance for Cloud Foundry you also must assign an entitlement of the *service_name* `APPLICATION_RUNTIME` and the *plan_name* `MEMORY`.

In contrast to entitlements for services and applications, this entitlement has some impact behind the scenes that could jeopardize your Terraform configuration.

## Solution Proposal

To avoid any dependency issues between the environment instance and the entitlement throughout the lifecycle of the resources, you must model the dependency explicitly namely:

1. Create the environment instance for Cloud Foundry.
2. Create the entitlement for `APPLICATION_RUNTIME` and `MEMORY` dpeneding on the environment instance resource.
