module "compile_server" {
  source = "./compile_server"
}

module "dev_server" {
  source = "./dev_server"
}

module "storage_server" {
  source = "./storage_server"
}

module "docker_server" {
  source = "./docker_server"
}
