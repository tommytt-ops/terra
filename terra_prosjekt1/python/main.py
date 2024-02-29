from linux_commands import all_server_list, truncate_ansible_hosts, apply_terraform, append_ips_to_hosts, run_playbook



if __name__ == "__main__":

    apply_terraform()
    ip_list = all_server_list()
    truncate_ansible_hosts()
    append_ips_to_hosts()
    run_playbook()