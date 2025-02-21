resource "aws_key_pair" "deployer" {
  key_name = "${var.project_name}-deployer-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_security_group" "allow_access" {
  name = "${var.project_name}-allow-access"
  description = "Allow Access to Debian"

  ingress {
    description = "ssh from vpc"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow Access"
  }
}

resource "aws_instance" "debian_web" {
  ami = data.aws_ami.debian.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [
  aws_security_group.allow_access.id
  ]
  tags = {
    Name = "Holi-${var.project_name}"
  }
}