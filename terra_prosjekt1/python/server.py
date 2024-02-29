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
                server_id = server_json['ID']
                server_name = server_json['Name']
                server_status = server_json['Status']
                server_ip = server_json['Networks']

                if server_ip != "acit=10.196.38.184" or server_ip != "acit=10.196.39.91":
                    server_info_list.append(server_ip)

        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
    else:

        print(f"Command failed with error: {result.stderr}")

    return server_info_list
