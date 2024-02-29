from linux_commands import all_server_list, truncate_ansible_hosts



if __name__ == "__main__":
    ip_list = all_server_list()
    truncate_ansible_hosts()