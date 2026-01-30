# Module: Role App ID Fetcher

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_btp"></a> [btp](#provider\_btp) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [btp_subaccount_roles.all](https://registry.terraform.io/providers/sap/btp/latest/docs/data-sources/subaccount_roles) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_role_collections"></a> [base\_role\_collections](#input\_base\_role\_collections) | Map of role names and role template names | <pre>map(list(object({<br/>    role_template_name = string<br/>    role_name          = string<br/>  })))</pre> | n/a | yes |
| <a name="input_subaccount_id"></a> [subaccount\_id](#input\_subaccount\_id) | The ID of the subaccount where the role collections should be fetched from. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enhanced_role_collections"></a> [enhanced\_role\_collections](#output\_enhanced\_role\_collections) | Role Collections with app\_ids of subaccount |
