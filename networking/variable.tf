#VPC
variable "vpc_cidr" {
  description = "VPC Cidr"
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