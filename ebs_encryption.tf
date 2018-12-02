# Configure the AWS Provider
provider "aws" {}

resource "aws_instance" "couchdb" {
  ami           = "ami-0c5199d385b432989"
  instance_type = "t2.micro"
  key_name      = "merxer.io"
  availability_zone = "ap-southeast-1a"
  user_data =<<-EOF
	    #!/bin/bash
	    apt update
	    apt install -y apt-transport-https ca-certificates curl software-properties-common
	    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
	    apt update
	    apt-cache policy docker-ce
	    apt install -y docker-ce
	    # install docker compose
	    curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	    chmod +x /usr/local/bin/docker-compose
	    # start couchdb
	    mkdir -p /opt/couchdb/data
	    mkdir -p /opt/couchdb/etc/local.d
	    docker run -p 5984:5984  -d \
	    --volume /opt/couchdb/data:/opt/couchdb/data \
	    --volume /opt/couchdb/etc/local.d:/opt/couchdb/etc/local.d  \
	    --env COUCHDB_USER=admin \
	    --env COUCHDB_PASSWORD=adminpassword \
	    apache/couchdb:2.2
	    # create database on couchdb
	    curl -X PUT  http://admin:adminpassword@127.0.0.1:5984/fwd_db
	    # insert data on couchdb
	    curl -X PUT http://admin:adminpassword@127.0.0.1:5984/fwd_db/doc -d '{"data": "data test"}'
	    EOF

  tags {
    Name = "Source"
  }
}
