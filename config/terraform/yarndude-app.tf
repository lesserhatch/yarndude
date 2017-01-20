# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
data "aws_availability_zones" "available" {}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "primary" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "secondary" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]
}

# A security group for the app web server
resource "aws_security_group" "web" {
  vpc_id = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Main web app server's keypair
resource "aws_key_pair" "web" {
  key_name   = "ec2-yarndude"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDagDJwveEzTUcOKCAxspJQ3I8FWeYCi7LHPL417SPyRHOIdyNkCwT5ofBfz8/O4poIYSFeZDnwK+e7Liravri6zQt1XEpxZ2QfE9Zmvc7/rH+DOPTmE+kAg8HxRv/m/e2ZPOd+kEWnjuh8TEDJnpO9rgEeXcuxHxAUwZK74gw9Y3QNERR5lWuBsIx7aSQRiQehWqmBwuYwwxwzpmZXJPcqcZ9Y8lnNGBkQiB9RQ+4pp5CsMluELyHCq8Ns35aorO1rx5z7xbeADimgso31OTiz9qu0/yoc4uPMNK6THOqd7CIhJSuEvyH+nRpdKfCFAXyIGz8Xc0wXg2VaV+314c8rpYbFLbK1yYt/H9/sCfhKstdXeCOHGQkaT9j2RPbEYWutCDac8JPNolFolG4iF6t5n38n6FOjxaa4yKeD8FAuzzdEeTZSc4OE8qhbTi0+1qpGjnbAjwQW+IbvRTNZ85s1YxUrLq2bHFG1TtKiNEcbkEkDNMd0KktM3aZUkir3kUmxMt244UUhTIl5UjNL1coYYQkyqIMmyDlYNwO4RTLQ2DsBB5TT709RakJcymmC8rnEH8+faWp5f8DnuRlhcZYdDIMfBoohlmdz1GQqrvzN4nlgAkWPPYgdfgzKPMMKbi1eGlN4MQ9QjRDhTvly69xIg5RUqxYORsbENhxZYNfG5w== swcharl@gmail.com"
}

# Main web app server instance
resource "aws_instance" "web" {
  ami                    = "ami-e13739f6"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.web.key_name}"
  vpc_security_group_ids = ["${aws_security_group.web.id}", "${aws_security_group.db.id}", "${aws_security_group.redis.id}"]
  subnet_id              = "${aws_subnet.primary.id}"
}

# A security group for the postgres server
resource "aws_security_group" "db" {
  vpc_id = "${aws_vpc.default.id}"

  # In/Out DB access in the VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }
}

# A security group for the redis server
resource "aws_security_group" "redis" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }
}

# Database instance
resource "aws_db_instance" "db" {
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "9.6.1"
  instance_class         = "db.t2.micro"
  name                   = "yarndudeproduction"
  username               = "yarndude"
  password               = "y4rndud3p4ssw0rd!"
  db_subnet_group_name   = "${aws_db_subnet_group.default.name}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
}

# Redis instance
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "yarndude-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  port                 = 6379
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  subnet_group_name    = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids   = ["${aws_security_group.redis.id}"]
}

# Create Route53 zone and records
resource "aws_route53_zone" "main" {
  name = "yarndude.com."
}

resource "aws_route53_record" "naked" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.web.public_ip}"]
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "www.${aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.web.public_ip}"]
}

resource "aws_route53_record" "zoho" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "zb14848362.${aws_route53_zone.main.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["zmverify.zoho.com"]
}

resource "aws_route53_record" "zoho-mx" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "300"
  records = ["10 mx.zoho.com", "20 mx2.zoho.com"]
}

resource "aws_route53_record" "zoho-spf" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 mx include:zoho.com ~all"]
}

resource "aws_route53_record" "zoho-dkim" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "zoho._domainkey.${aws_route53_zone.main.name}"
  type    = "TXT"
  ttl     = "300"
  records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzxOKD2NDlIdf+gauHXL/5v/kVT4CF7IdSEHRPTO0TlJexaiUy16CSGHlDWvGvldec+NeEKSmtkszX/ngbG/4ulUcIYmUKZdCv0DpUVn1yrjIAJJNzG2F/iz+5EFIvJJkCsag4z164UsTgOLG4+pe6CGJVyKTCfv7PE5TppCFfSQIDAQAB"]
}

resource "aws_route53_zone" "private" {
  name   = "private.${aws_route53_zone.main.name}"
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route53_record" "private-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${aws_route53_zone.private.name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]
}

resource "aws_route53_record" "private-db" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "db.${aws_route53_zone.private.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.db.address}"]
}

resource "aws_route53_record" "private-redis" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "redis.${aws_route53_zone.private.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elasticache_cluster.redis.cache_nodes.0.address}"]
}
