job "currenttime" {

    region = "global"

    datacenters = ["dc1"]

    type = "service"

    update {
        max_parallel = 1
        min_healthy_time = "10s"
        progress_deadline = "10m"
        auto_revert = false
        canary = 0
    }

    migrate {
        max_parallel = 1
        health_check = "checks"
        min_healthy_time = "10s"
        healthy_deadline = "5m"
      }


    group "currenttime" {

        count = 1

        network {
            port "web" {
                to = 8080
            }
        }

        # for consul
        service {
            name = "web"
            tags = ["global", "web"]
            port = "web"
        }

        # check {
      #   name     = "alive"
      #   type     = "tcp"
      #   interval = "10s"
      #   timeout  = "2s"
      # }

        

        restart {
            attempts = 2
            interval = "30m"
            delay = "15s"
            mode = "fail"
        }

        ephemeral_disk {
            size = 300
        }


        task "web" {
            driver = "docker"

            config {
                image = "zharling/currenttime:latest"

                ports = ["web"]
            }

            # artifact {
        #   source = "http://foo.com/artifact.tar.gz"
        #   options {
        #     checksum = "md5:c4aa853ad2215426eb7d70a21922e794"
        #   }
        # }

            resources {
                cpu    = 500 # 500 MHz
                memory = 256 # 256MB
            }
        }
    }
}