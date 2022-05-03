# Full configuration options can be found at https://www.nomadproject.io/docs/configuration

data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "dc1"

advertise {
  http = "{{ GetInterfaceIP `eth1` }}"
  rpc  = "{{ GetInterfaceIP `eth1` }}"
  serf = "{{ GetInterfaceIP `eth1` }}"
}

server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/etc/nomad.d/nomad.hcl"
  enabled = true
  bootstrap_expect = 3
}

client {
  enabled           = true
  network_interface = "eth1"
  servers           = ["192.168.56.101", "192.168.56.102", "192.168.56.103"]
}