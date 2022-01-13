#created the s3 bucket:

resource "aws_s3_bucket" "tfstate" {
  bucket = "talent-terraform-2021-project"
  acl    = "private"


  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}


#Backend: 
terraform {
  backend "s3" {
    bucket = "talent-terraform-2021-project"
    key    = "challenegeweek/ProjectX.tfstates"

  }
}


resource "aws_dynamodb_table" "terraform_lock_tbl" {
  name           = "terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock"
  }
}