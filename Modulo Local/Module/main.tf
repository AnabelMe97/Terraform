provider "aws" {
  region = "eu-west-3"
}

module "llama" {
  source = "./MyModule"
  mivar  = "Entrada"
}

output "salida-main" {
  value = module.llama.salida
}