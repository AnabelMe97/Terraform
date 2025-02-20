provider "aws" {
  region = "eu-west-3"
}

## desplegamos key pair

resource "aws_key_pair" "claves_debian" {
  key_name = "deployer-key-debian-${var.project_name}"
  public_key = file(var.ssh_key_path)
}

## Creamos SG

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh-${var.project_name}"
  description = "Allow Inbound traffic ssh"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

## Desplegamos la instancia

resource "aws_instance" "vm_debian" {
  ami = data.aws_ami.debian.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.claves_debian.key_name
  vpc_security_group_ids = [
  aws_security_group.allow_ssh.id
  ]
  tags = {
    Name = "Holi-${var.project_name}"
  }
  provisioner "local-exec" {
    command = "echo El id es ${self.id}"
  }

  connection {
    type = "ssh"
    user = "debian"
    host = self.public_ip
    private_key = file(var.ssh_key_private_path)
  }

  provisioner "remote-exec" {
    inline = [
    "echo holi >> test.txt"
    ]
  }
}

output "ip_instance" {
  value = aws_instance.vm_debian.public_ip
}

output "ssh" {
  value = "ssh -l debian ${aws_instance.vm_debian.public_ip}"
}

