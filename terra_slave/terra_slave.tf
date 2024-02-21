terraform {
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
    }
 }
}

provider "openstack" {
    cloud = "openstack" # defined in ~/.config/openstack/clouds.yaml
}

resource "openstack_compute_instance_v2" "install_instance" {
  name = "exec2"
  image_name = "ubuntu-22.04-LTS"
  flavor_name = "css.1c1r.10g"
  key_pair = "key"
  security_groups = ["default"]

  network {
  name = "acit"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = openstack_compute_instance_v2.install_instance.access_ip_v4
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "sudo apt update",
      "sudo apt -y install puppet"
    ]
  }
}
