import subprocess
import json


def all_server_list():
  
    server_info_list = []

    command = "openstack --os-cloud=openstack server list --format json"

    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)

    if result.returncode == 0:
        try:
            
            server_data = json.loads(result.stdout)
            for server_json in server_data:
                
                server_ip = server_json['Networks']
                server_info_list.append(server_ip)

        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
    else:

        print(f"Command failed with error: {result.stderr}")

    return server_info_list
