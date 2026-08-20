variable "secret_names" {
  description = "Map of stable keys to Secrets Manager secret names."
  type        = map(string)
}

variable "recovery_window_in_days" {
  description = "Recovery window used if a secret is destroyed."
  type        = number
  default     = 7
}
