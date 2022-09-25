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

variable "department" {
  type        = string
  description = "department" 
  default     = "IT"
}

variable "job_title" {
  type        = string
  description = "job_title"
  default     = "System Administrator"

}
