# ----------------------- ELASTIC CACHE -------------------------------
variable "ec_node_type" {
  description = "The instance type for each node in the cluster"
  type        = string
  default     = "cache.t2.medium"
}

variable "ec_nodes_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "ec_az_mode" {
  type        = string
  description = "Specifies whether the nodes is going to be created across azs or in a single az"
  default     = "cross-az"

  validation {
    condition     = var.ec_az_mode == "cross-az" || var.ec_az_mode == "single-az"
    error_message = "The az_mode value can only be 'cross-az' or 'single-az'."
  }
}

variable "ec_memcached_port" {
  description = "The Memcache port that the nodes will be listing on"
  type        = number
  default     = 11211
}

# ----------------------- LAUNCH CONFIGURATION FOR WORDPRESS-----------
variable "lc_name_prefix" {
  description = "Launch configuration prefix name"
  default     = "wordpress-"
}

variable "lc_image_id" {
  description = "Launch configuration image id"
  default     = "ami-087c17d1fe0178315"
}

variable "lc_instance_type" {
  description = "Launch configuration instance type"
  default     = "t2.micro"
}

variable "lc_key_name" {
  description = "Launch configuration key name"
  default     = "madra"
}

# ----------------------- ASG FOR WORDPRESS ----------------------------
variable "asg_wordpress_desired_capacity" {
  type        = number
  description = "Auto Scaling Group name"
  default     = 1
}
variable "asg_wordpress_min_size" {
  description = "Auto Scaling Group name"
  default     = 1
  type        = number
}
variable "asg_wordpress_max_size" {
  description = "Auto Scaling Group name"
  default     = 4
  type        = number
}

# ----------------------- LAUNCH CONFIGURATION FOR BASTION -----------
variable "lc_bastion_name_prefix" {
  description = "Launch configuration prefix name"
  default     = "bastion-"
}

variable "lc_bastion_instance_type" {
  description = "Launch configuration instance type"
  default     = "t2.micro"
}

variable "lc_bastion_key_name" {
  description = "Launch configuration key name"
  default     = "madra"
}

# ----------------------- ASG FOR BASTION ----------------------------
variable "asg_bastion_name" {
  description = "Auto Scaling Group name"
  default     = "asg-bastion"
  type        = string
}
variable "asg_bastion_desired_capacity" {
  type        = number
  description = "Auto Scaling Group name"
  default     = 1
}
variable "asg_bastion_min_size" {
  description = "Auto Scaling Group name"
  default     = 1
  type        = number
}
variable "asg_bastion_max_size" {
  description = "Auto Scaling Group name"
  default     = 2
  type        = number
}

# ----------------------- RDS ----------------------------------------
variable "cluster_identifier" {
  type        = string
  description = "Company name for resource tagging"
  default     = "wordpress-db-cluster"
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
