data_dir = "/opt/consul"

server           = false
datacenter       = "dc1"
advertise_addr   = "{{ GetInterfaceIP `eth1` }}"
enable_syslog    = true
start_join       = ["192.168.56.101", "192.168.56.102", "192.168.56.103"]