#VPC
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "Main_VPC"
vpc_internet_gateway = "internet_gateway"

#subnets
PublicSubnetA_cidr = "10.0.1.0/24"
PublicSubnetA_az = "eu-west-1a"
PublicSubnetB_cidr = "10.0.2.0/24"
PublicSubnetB_az = "eu-west-1b"

PrivateSubnetA_cidr = "10.0.5.0/24"
PrivateSubnetA_az = "eu-west-1a"
PrivateSubnetB_cidr = "10.0.6.0/24"
PrivateSubnetB_az = "eu-west-1b"

DBSubnetA_cidr = "10.0.10.0/24"
DBSubnetA_az = "eu-west-1a"
DBSubnetB_cidr = "10.0.20.0/24"
DBSubnetB_az = "eu-west-1b"