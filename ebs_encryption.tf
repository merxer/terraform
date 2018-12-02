# Configure the AWS Provider
provider "aws" {}

resource "aws_instance" "couchdb" {
  ami           = "ami-0eb1f21bbd66347fe"
  instance_type = "t2.medium"
  key_name      = "merxer.io"
  availability_zone = "ap-southeast-1a"

  tags {
    Name = "Source"
  }
}
