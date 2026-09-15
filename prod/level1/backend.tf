terraform {
  backend "s3" {
    bucket         = "my-kops-state-bucket15208"
    key            = "terraform-statefile/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "use_lockfile"
    encrypt        = true
  }
}
