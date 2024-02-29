import subprocess
import json

def all_server_list():
    ip_list = []  # This will store only the IP addresses

    command = "openstack --os-cloud=openstack server list --format json"
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)

    if result.returncode == 0:
        try:
            server_data = json.loads(result.stdout)
            for server_json in server_data:
                # Assuming 'Networks' contains a dictionary with 'acit' as a key
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
