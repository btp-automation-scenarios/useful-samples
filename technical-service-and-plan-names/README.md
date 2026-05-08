# Determine technical service and plan names for entitlements

## Problem Statement

Deriving the technical names of services and service plans and also their availability in data centers can be challenging. There is no central place like help.sap.com to find this information, and it can be time-consuming to gather it. In addition, the information is not in a machine-readable format. This can lead to delays in automating setups and can be frsutrating when using wrong technical names.

## Solution Proposal

To address this issue we use the btp CLI as entry point to the netitlements on global account level. We wrapped the btp CLI in a script (Windows PowerShell and macOS/Linux bash) to give you the following options:

- Get a list of all services that your subaccount is entitled to inclduding their technical names and descriptions as well as the plans assigned to these services. The information about the plans is enriched by the information about the availability of the servcies in data centers and the underlying Hyperscaler of the data center
- Get the information about one specific service identified by the name or display name of the service. The output is the same as for the list of all services but only for the service you are interested in.

The results are stored as JSON file in the current directory. You can use this file for your automation scripts to determine the technical names of services and plans and their availability in data centers.
