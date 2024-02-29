from linux_commands import all_server_list, truncate_ansible_hosts, apply_terraform



if __name__ == "__main__":
    
    apply_terraform()
    ip_list = all_server_list()
    truncate_ansible_hosts()