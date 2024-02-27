terraform {
  required_providers {
   openstack = {
    source = "terraform-provider-openstack/openstack"
  }
 }
}

provider "openstack" {
        cloud = "openstack" 
}

resource "openstack_compute_instance_v2" "docker_instance" {
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
                "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
                "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
                "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
                "sudo apt-get update",
                "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin",
            ]
        }



}