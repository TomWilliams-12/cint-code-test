variable "name" {
  type        = string
  default     = "lucid-code-test"
  description = "Root name for resources in this project"
}

variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC cidr block"
}

variable "newbits" {
  default     = 8
  type        = number
  description = "How many bits to extend the VPC cidr block by for each subnet"
}

variable "public_subnet_count" {
  default     = 3
  type        = number
  description = "How many subnets to create"
}

variable "private_subnet_count" {
  default     = 3
  type        = number
  description = "How many private subnets to create"
}

variable "instance_type" {
  default     = "t2.nano"
  type        = string
  description = "EC2 instance type"
}

variable "instance_count" {
  default     = 2
  type        = number
  description = "How many instances to create"
}

variable "db_engine" {
  default     = "postgres"
  type        = string
  description = "Application Database Engine"
}

variable "db_engine_version" {
  default     = "14.6"
  type        = string
  description = "Application Engine Version"
}

variable "db_instance_class" {
  default     = "db.t3.micro"
  type        = string
  description = "DB instance type"
}

variable "db_username" {
  type        = string
  sensitive   = true
  description = "DB Username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "DB Password"
}

variable "db_port" {   
  default     = 5432  
  type        = number
  description = "database port number"
}