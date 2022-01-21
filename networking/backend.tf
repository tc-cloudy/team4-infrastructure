#Backend: 
terraform {
  backend "s3" {
    bucket = "talent-terraform-2021-project"
    key    = "challenegeweek/ProjectX.tfstates"

  }
}
