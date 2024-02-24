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

resource "openstack_compute_instance_v2" "slave3_instance" {
        name = "master_pro1"
        image_name = "ubuntu-22.04-LTS"
        flavor_name = "C2R4_10G"
        key_pair = "key"
        security_groups = ["default"]

        network {
        name = "acit"
        }

        connection {
         type = "ssh"
         user = "ubuntu"
         private_key = "${file("~/.ssh/id_rsa")}"
         host = openstack_compute_instance_v2.slave3_instance.access_ip_v4
        }

        provisioner "remote-exec" {
         inline = [
                "sleep 20",
                "curl -LO https://apt.puppet.com/puppet8-release-jammy.deb",
                "sudo dpkg -i ./puppet8-release-jammy.deb",
                "sudo apt update",
                "sudo apt install -y puppetserver",
                "sudo apt install -y python3-openstackclient",
                "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg",
                "echo deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com/ $(lsb_release -cs) main | sudo tee /etc/apt/sources.list.d/hashicorp.list",
                "sudo apt update && sudo apt install terraform",
                "sudo mkdir /home/ubuntu/.config",
                "sudo mkdir /home/ubuntu/.config/openstack",
                "sudo chown ubuntu: /home/ubuntu/.config/openstack",
                "sudo apt -y install software-properties-common",
                "sudo apt-add-repository ppa:ansible/ansible -y",
                "sudo apt install ansible -y",
                "sudo apt-get install -y git-all",
                "ssh-keygen -q -N \"\" -f /home/ubuntu/.ssh/id_rsa",
                "sudo git clone https://github.com/tommytt-ops/terra",
            ]
        }

        provisioner "file" {
            source      = "/Users/tommytran/.config/openstack/clouds.yml" 
            destination = "/home/ubuntu/.config/openstack/clouds.yml"
        }

        provisioner "remote-exec" {
         inline = [
                "openstack --os-cloud=openstack keypair delete masterKey",
                "openstack --os-cloud=openstack keypair create --public-key ~/.ssh/id_rsa.pub masterKey",       
            ]
        }

}