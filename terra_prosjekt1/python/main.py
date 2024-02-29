from linux_commands import all_server_list, truncate_ansible_hosts
ip_list = []
if not ip_list:
    truncate_ansible_hosts()
    ip_list = all_server_list()


