import subprocess
import json
import subprocess
import os

def all_server_list():
    ip_list = []  

    command = "openstack --os-cloud=openstack server list --format json"
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)

    if result.returncode == 0:
        try:
            server_data = json.loads(result.stdout)
            for server_json in server_data:
                
                network_info = server_json['Networks']
                
                if 'acit' in network_info and isinstance(network_info['acit'], list):
                    ip_list.extend(network_info['acit'])
           
            if len(ip_list) > 2:
                ip_list = ip_list[:-2]

        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
    else:
        print(f"Command failed with error: {result.stderr}")

    return ip_list

import subprocess

def truncate_ansible_hosts():
    command = "sudo truncate -s 0 /etc/ansible/hosts"
    try:
        result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode == 0:
            print("Successfully truncated /etc/ansible/hosts")
        else:
            print(f"Error truncating /etc/ansible/hosts: {result.stderr}")
    except Exception as e:
        print(f"Failed to run truncate command: {e}")

def apply_terraform():
    terraform_directory = '../'
    os.chdir(terraform_directory)  

    subprocess.run("terraform init", shell=True, check=True)

    result = subprocess.run("echo yes | terraform apply", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    if result.returncode == 0:
        print("Terraform apply was successful")
        print(result.stdout)
    else:
        print("Terraform apply failed")
        print(result.stderr)

    original_directory = os.getcwd()
    os.chdir(original_directory)


def append_ips_to_hosts(ip_list):
    ip_str = "\n".join(ip_list)
    
    echo_command = f"echo \"{ip_str}\""
    
    command = f"{echo_command} | sudo tee -a /etc/ansible/hosts"
 
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
 
    if result.returncode == 0:
        print("IPs successfully appended to /etc/ansible/hosts")
    else:
        print("Failed to append IPs to /etc/ansible/hosts")
        print(result.stderr)

def run_playbook():
    playbook_directory = "../ansible_playbook"
    os.chdir(playbook_directory)  

    result = subprocess.run("ansible-playbook -i /etc/ansible/hosts prosjekt1.ansible.yml", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    if result.returncode == 0:
        print("Playbook applied")
    else:
        print("Playbook failed")
        print(result.stderr)



  







