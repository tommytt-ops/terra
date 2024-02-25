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

resource "openstack_compute_instance_v2" "dev_server" {
  count             = 2 
  name              = "DevServer-${count.index}"
  image_name        = "ubuntu-22.04-LTS"
  flavor_name       = "css.1c1r.10g" 
  key_pair          = "masterKey"
  security_groups   = ["default"]

  network {
    name = "acit"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/ubuntu/.ssh/id_rsa")
    host        = self.access_ip_v4
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "sudo apt update",
      "sudo apt install -y jed", 
      "sudo apt-get install -y git-all",
      "sudo apt install -y emacs"
    ]
  }
}
