terraform {
  required_providers {
   openstack = {
    source = "terraform-provider-openstack/openstack"
  }
 }
}

provider "openstack" {
        cloud = "openstack" # defined in ~/Users/tommytran/.config/openstack/clouds.yaml
}

resource "openstack_compute_instance" "docker_instance" {
        name = "docker_server"
        image_name = "ubuntu-22.04-LTS"
        flavor_name = "C2R4_10G"
        key_pair = "masterKey"
        security_groups = ["default"]

        network {
        name = "acit"
        }

        connection {
         type = "ssh"
         user = "ubuntu"
         private_key = "${file("~/.ssh/id_rsa")}"
         host = self.access_ip_v4
        }

        provisioner "remote-exec" {
            inline = [
                "sleep 20",
                "sudo apt-get update",
                "sudo apt-get install ca-certificates curl",
                "sudo install -m 0755 -d /etc/apt/keyrings",
                "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
                "sudo chmod a+r /etc/apt/keyrings/docker.asc",
                "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc",
                "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
                "sudo apt-get update",
                "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
    
            ]
  }


}