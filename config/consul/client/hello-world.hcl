service {
  name = "hello-world"
  id   = "hello-world"
  port = 8080
  tags = ["primary"]
}

check  {
  id = "hello-world"
  name = "Check of HTTP site on port 8080"
  http = "http://localhost:8080"
  tls_server_name =  ""
  tls_skip_verify = false
  interval =  "10s"
  timeout =  "1s"
}