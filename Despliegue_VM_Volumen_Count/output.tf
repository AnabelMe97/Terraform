/*output "instance_ip" {
  value = aws_instance.debian.public_ip
  description = "The Instance Public Ip"
}
output "eip_ip" {
  value = aws_eip.eip.public_ip
  description = "the eip for ssh access"
}
output "ssh" {
  value = "ssh -l debian ${aws_eip.eip.public_ip}"
}
output "url" {
  value = "https://${aws_eip.eip.public_ip}"
}*/

output "instance_public_ip" {
  value = aws_instance.debian[*].public_ip
  description = "Ips publicas de las instancias web"
}
output "ssh_commands" {
  value = [
    for ip in aws_instance.debian[*].public_ip : "ssh admin@${ip}"
  ]
}