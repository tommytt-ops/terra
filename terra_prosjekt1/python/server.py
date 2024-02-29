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
  
                server_info_list.append({"ID": server_id, "Name": server_name, "Status": server_status})
        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
    else:

        print(f"Command failed with error: {result.stderr}")

    return server_info_list
