resource "aws_key_pair" "deployer-key" {
  key_name = "${var.project_name}-deployer-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_ebs_volume" "debian" {
  availability_zone = var.availability_zone
  size              = 4
  type              = "gp3"
  encrypted         = true
  tags = {
    Name = "${var.project_name}-debian-ebs"
  }
}

resource "aws_security_group" "allow_traffic" {
  name = "allw_ssh_${var.project_name}"
  description = "Allow all of the traffic to the instance"
  vpc_id = var.vpc_id

  ingress {
    description = "Ssh from VPC ${var.project_name}"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC ${var.project_name}"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC ${var.project_name}"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "debian" {
  ami = data.aws_ami.debian.id
  availability_zone = var.availability_zone
  instance_type = var.instance_type
  vpc_security_group_ids = [
  aws_security_group.allow_traffic.id
  ]
  user_data = templatefile(
    "${path.module}/userdata.sh",
    {}
  )
  key_name = aws_key_pair.deployer-key.key_name
  tags = {
    Name = "${var.project_name}-debian-web-instance"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.debian.id
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-debian-web-epi"
  }
}

resource "aws_volume_attachment" "debian" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.debian.id
  instance_id = aws_instance.debian.id
}