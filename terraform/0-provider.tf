provider "aws" {
  alias   = "source"
  profile = "source"
  region  = "us-east-2"
}

provider "aws" {
  alias   = "destination"
  profile = "destination"
  region  = "us-east-2"
}