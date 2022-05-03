locals {
  flow_name = "custom_access"
}

# The Flow that grants users access to custom targets.
resource "sym_flow" "this" {
  name  = local.flow_name
  label = "Custom Access"

  template = "sym:template:approval:1.0.0"

  implementation = "${path.module}/impl.py"

  environment_id = var.sym_environment.id

  vars = var.flow_vars

  params = {
    strategy_id = sym_strategy.this.id

    prompt_fields_json = jsonencode(
      [
        {
          name     = "reason"
          type     = "string"
          required = true
        }
      ]
    )
  }
}

# The Strategy your Flow uses to manage access.
resource "sym_strategy" "this" {
  type = "custom"

  name           = local.flow_name
  implementation = "${path.module}/strategy.py"
  integration_id = sym_integration.custom.id
  targets        = [for target in var.targets : sym_target.targets[target["identifier"]].id]
}

# The targets that your Sym Strategy manages access to.
resource "sym_target" "targets" {
  for_each = { for target in var.targets : target["identifier"] => target["label"] }

  type = "custom"

  name  = "${local.flow_name}-${each.key}"
  label = each.value

  settings = {
    identifier = each.key
  }
}

# An API key for making requests to escalate/deescalate users.
resource "sym_secret" "api_key" {
  path      = var.secrets_settings.path
  source_id = var.secrets_settings.source_id

  settings = {
    json_key = var.secret_json_key
  }
}

# A custom Integration can be used to access secrets in your custom strategy implementation
# as well as manage identities.
resource "sym_integration" "custom" {
  type        = "custom"
  name        = local.flow_name
  external_id = var.integration_identifier

  settings = {
    api_token_secret = sym_secret.api_key.id
  }
}
