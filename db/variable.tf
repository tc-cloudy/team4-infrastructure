
variable "DBSubnetA_cidr" {
  description = "DB subnet cidr"
  type        = string
}
variable "DBSubnetA_az" {
  description = "DB subnet AZ"
  type        = string
}

variable "DBSubnetB_cidr" {
  description = "DB subnet cidr"
  type        = string
}
variable "DBSubnetB_az" {
  description = "DB subnet AZ"
  type        = string
}

variable "aws_wp_db_password" {
  description = "DB PWD"
  type        = string
}

variable "aws_wp_db_user" {
  description = "DB USER"
  type        = string
}
