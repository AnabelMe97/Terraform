## fichero para recoger los datos de la AMI

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name = "name"
    values = ["debian-12-amd64-20250210-2019"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["136693071363"] ## owner debian oficial
}