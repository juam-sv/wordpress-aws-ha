variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "noticias-da-nuvem"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "wordpress"
}

variable "enviroment" {
  type        = string
  description = "Environment name for resource tagging"
  default     = "staging"
}

variable "ec2_sg_ingress_ports" {
  type        = list(number)
  description = "Inbound SG ports to be opened"
  default     = [22, 80, 443]
}

variable "vpc_configuration" {
  type = object({
    cidr_block = string
    subnets = list(object({
      name       = string
      cidr_block = string
      public     = bool
    }))
    subnets_data = list(object({
      name       = string
      cidr_block = string
      public     = bool
    }))
  })
  default = {
    cidr_block = "10.0.0.0/16"
    subnets = [
      {
        name       = "app-a"
        cidr_block = "10.0.0.0/19"
        public     = false
      },
      {
        name       = "app-b"
        cidr_block = "10.0.32.0/19"
        public     = false
      },
      {
        name       = "public-a"
        cidr_block = "10.0.128.0/19"
        public     = true
      },
      {
        name       = "public-b"
        cidr_block = "10.0.160.0/19"
        public     = true
      }
    ]
    subnets_data = [
      {
        name       = "data-a"
        cidr_block = "10.0.64.0/19"
        public     = false
      },
      {
        name       = "data-b"
        cidr_block = "10.0.192.0/19"
        public     = false
      }
    ]
  }
}
