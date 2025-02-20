## Fichero para declarar todas las variables

variable "ssh_key_path" {
  type = string
  description = "path de la clave publica"
}
variable "project_name" {
  type = string
  description = "nombre del proyecto"
}
variable "ssh_key_private_path" {
  type = string
  description = "path de la clave privada"
}
variable "vpc_id" {
  type = string
  description = "id de la VPC en la que vamos a desplegar"
}