variable "username" {
  type        = string
  description = "Username"
}

variable "domain_name" {
  type        = string
  description = "AAD domain name"
}

variable "password" {
  type        = string
  description = "Temporary password"
}

variable "job_title" {
  type        = string
  description = "Temporary password"
  default     = "Cloud Administrator"

}
