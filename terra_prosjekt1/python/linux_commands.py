import subprocess
import json

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

truncate_ansible_hosts()

truncate_ansible_hosts()
ip_list = all_server_list()


