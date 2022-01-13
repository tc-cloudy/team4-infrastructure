variable "vpc_cidr" {
  description = "VPC Cidr"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_internet_gateway" {
  description = "Internet gateway"
  type        = string
}

#subnets
variable "PublicSubnetA_cidr" {
  description = "Public subnet cidr"
  type        = string
}
variable "PublicSubnetA_az" {
  description = "Public subnet AZ"
  type        = string
}

variable "PublicSubnetB_cidr" {
  description = "Public subnet cidr"
  type        = string
}
variable "PublicSubnetB_az" {
  description = "Public subnet AZ"
  type        = string
}

variable "PrivateSubnetA_cidr" {
  description = "Private subnet cidr"
  type        = string
}
variable "PrivateSubnetA_az" {
  description = "Private subnet AZ"
  type        = string
}

variable "PrivateSubnetB_cidr" {
  description = "Private subnet cidr"
  type        = string
}
variable "PrivateSubnetB_az" {
  description = "Private subnet AZ"
  type        = string
}

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