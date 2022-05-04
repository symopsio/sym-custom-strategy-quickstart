variable "flow_vars" {
  description = "Configuration values for the Flow implementation Python."
  type        = map(string)
}

variable "integration_identifier" {
  description = "An identifier for your custom integration."
  type        = string
  default     = "custom"
}

variable "secret_json_key" {
  description = "Name of the key that maps to the API key within your Secrets Manager Secret."
  type        = string
  default     = "api_token"
}

variable "secrets_settings" {
  description = "Secrets source and path for shared secret lookups."
  type = object(
    { source_id = string, path = string }
  )
}

variable "sym_environment" {
  description = "Sym Environment for this Flow."
  type        = object({ id = string, name = string })
}

variable "targets" {
  description = "List of targets that end-users can request access to. Each object has a label and an identifier."
  type = list(object(
    { label = string, identifier = string }
  ))
}
