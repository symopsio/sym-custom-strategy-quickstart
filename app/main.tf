provider "aws" {
  region = var.aws_region
}

provider "sym" {
  org = var.sym_org_slug
}

# A Sym Runtime that executes your Flows.
module "sym_runtime" {
  source = "../modules/sym-runtime"

  error_channel      = var.error_channel
  runtime_name       = var.runtime_name
  slack_workspace_id = var.slack_workspace_id
  sym_account_ids    = var.sym_account_ids
  tags               = var.tags
}

# A Flow that can manage access to a list of IAM target groups.
module "custom_access_flow" {
  source = "../modules/custom-access-flow"

  flow_vars        = var.flow_vars
  runtime_settings = module.sym_runtime.runtime_settings
  sym_environment  = module.sym_runtime.prod_environment
  targets          = var.targets
  tags             = var.tags
}
