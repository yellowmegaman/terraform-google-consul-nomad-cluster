datacenter = "${datacenter}"
bind_addr = "0.0.0.0"
data_dir  = "/var/nomad"

advertise {
  http = "{{GetPrivateIP}}"
  rpc  = "{{GetPrivateIP}}"
  serf = "{{GetPrivateIP}}"
}

server {
  enabled            = ${server_bool}
  bootstrap_expect   = ${bootstrap_expect}
  rejoin_after_leave = true
}

client {
  enabled = ${client_bool}
  options {
    "driver.raw_exec.enable"     = "1"
    "docker.cleanup.image"       = true
    "docker.cleanup.image.delay" = "3h"
  }
}

consul {
  address = "127.0.0.1:8500"
  server_auto_join = true
  client_auto_join = true
}

enable_syslog = true
log_level     = "DEBUG"

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}
