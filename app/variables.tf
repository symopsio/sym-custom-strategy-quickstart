variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "error_channel" {
  description = "The Slack channel where Sym errors will be surfaced."
  type        = string
  default     = "#sym-errors"
}

variable "flow_vars" {
  description = "Configuration values for the Flow implementation Python"
  type        = map(string)
  default     = {}
}

variable "targets" {
  description = "List of custom targets that end-users can request access to. Each object has a label and an identifier."
  type = list(object(
    { label = string, identifier = string }
  ))
}

variable "runtime_name" {
  description = "Name to assign to the Sym Runtime and its associated resources."
  type        = string
  default     = "shared"
}

variable "slack_workspace_id" {
  description = "The Slack Workspace ID to use for your Slack integration"
  type        = string
}

variable "sym_account_ids" {
  description = "List of account ids that can assume the Sym runtime role. By default, only Sym production accounts can assume the runtime role."
  type        = list(string)
  default     = ["803477428605"]
}

variable "sym_org_slug" {
  description = "Sym org slug for your org"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
