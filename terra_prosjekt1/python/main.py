from linux_commands import all_server_list, truncate_ansible_hosts


def main():
    truncate_ansible_hosts()
    ip_list = all_server_list()

if __name__ == "__main__":
    main()





