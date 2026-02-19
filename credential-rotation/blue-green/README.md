# Blue-green-based credential rotation for service instance bindings

This approach uses the community provider [rotating](https://registry.terraform.io/providers/Apollorion/rotating/1.0.0) by Apollorion.

As an alternative there is the community provider [rotating](https://registry.terraform.io/providers/movehq/rotating/1.0.0) by MoveHQ which contains the same logic.

As mentioned in the main README, the maintenance state of the providers is unclear. However, the logic of the providers is straightforward and can be easily implemented in a custom provider.
