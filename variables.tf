variable "userlist-cloudadmin" {
  type    = list(string)
  default = ["mac", "roy", "Arthur", "anitta"]
}

variable "userlist-sysadmin" {
  type    = list(string)
  default = ["john", "nicolas"]
}

variable "password" {
  type        = string
  description = "Temporary password"
  default     = "Str0ng3stP@sswd3ver!"
}

variable "environment" {
  type        = string
  description = "which environment?"
  default     = "DEV"
}

variable "md_content" {
  description = "Content for the MD tile"
  default     = "# Hello all :)"
}

variable "video_link" {
  description = "Link to a video"
  default     = "https://www.youtube.com/watch?v=......"
}

variable "location" {
  description = "The location where the resources will be deployed."
  default     = "eastus"
}



