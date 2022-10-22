variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "noticias-da-nuvem"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default = "wordpress"
}

variable "enviroment" {
  type        = string
  description = "Environment name for resource tagging"
  default = "staging"
}