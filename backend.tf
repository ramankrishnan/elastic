terraform {
  backend "s3" {
    bucket = "raman-terraform-state-123"
    key    = "terraform/state.tfstate"
    region = "ap-south-1"
  }
}
