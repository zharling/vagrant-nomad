data_dir = "/opt/consul"

server           = true
bootstrap_expect = 3
advertise_addr   = "{{ GetInterfaceIP `eth1` }}"
client_addr      = "0.0.0.0"
ui               = true
datacenter       = "dc1"
retry_join       = ["192.168.56.101", "192.168.56.102", "192.168.56.103"]

connect {
  enabled = true
}

addresses {
  grpc = "127.0.0.1"
}

ports {
  grpc  = 8502
}