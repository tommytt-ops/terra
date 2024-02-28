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

resource "openstack_compute_instance_v2" "storage_server" {
  count             = 2 
  name              = "StorageServer-${count.index}"
  image_name        = "ubuntu-22.04-LTS"
  flavor_name       = "css.1c2r.10g" 
  key_pair          = "masterKey"
  security_groups   = ["default"]

  network {
    name = "acit"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.access_ip_v4
  }

  provisioner "remote-exec" {
  inline = [
    "sleep 20",
    "sudo apt-get update",
    "sudo apt install -y software-properties-common",
    "sudo add-apt-repository -y ppa:gluster/glusterfs-7",
    "sudo apt update",
    "sudo apt install -y glusterfs-server"
  ]
}


}
