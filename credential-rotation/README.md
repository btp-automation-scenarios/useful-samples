# Credential Rotation

## Problem Statement

When creating service instance bindings one would like to rotate the binding after a specific amount of time for security reasons. However, there is no out-of-the-box solution for this.

## Solution Proposal

In general, there are two options to rotate credentials for service instance bindings:

- Use the resource [`time_rotating`](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) of HashiCorps [time](https://registry.terraform.io/providers/hashicorp/time) provider
- Use a custom provider to mock a *blue-green* approach. This approach has the downside that there is no official provider available and the maintenance state of the community providers is unclear. However, the logic of the providers is straightforward and can be easily implemented in a custom provider.

Sample code for the two options is available in the sub-directories of this folder:

- [`time-rotating`](./time-rotating/README.md)
- [`blue-green`](./blue-green/README.md)

In both scenario we assume a setup of a subaccount with a service instance and assigned service bindings. The service bindings should then be propagated to a destination as authentication credentials.
