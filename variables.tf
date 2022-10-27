# ----------------------- RDS ----------------------------------------
variable "cluster_identifier" {
  type        = string
  description = "Company name for resource tagging"
  default     = "wordpress_db_cluster"
}



variable "db_engine" {
  description = "The database engine"
  type        = string
  default     = "mysql"
}
variable "db_allocated_storage" {
  description = "The amount of allocated storage."
  type        = number
  default     = 10
}
variable "db_storage_type" {
  description = "type of the storage"
  type        = string
  default     = "gp2"
}

variable "db_instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  default     = "default.mysql5.7"
  type        = string
}
variable "db_engine_version" {
  description = "The engine version"
  default     = "8.0.28"
  type        = string
}
variable "skip_final_snapshot" {
  description = "skip snapshot"
  default     = true
  type        = bool
}
variable "db_port" {
  description = "The port on which the DB accepts connections"
  default     = "3306"
  type        = number
}

# ----------------------- RDS CREDENTIALS ----------------------------
variable "db_master_username" {
  description = "Username for the master DB user."
  default     = "wordpress"
  type        = string
  sensitive   = true

}
variable "db_master_password" {
  description = "password of the database"
  default     = "supersenha123"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The database name"
  default     = "wordpress"
  type        = string
  sensitive   = true
}

# ----------------------- TAGS AND ENVIROMENT -----------------------
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

# ----------------------- SG ----------------------------------------
variable "ec2_sg_ingress_ports" {
  type        = list(number)
  description = "Inbound SG ports to be opened"
  default     = [22, 80, 443]
}

# ----------------------- VPC ----------------------------------------
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
