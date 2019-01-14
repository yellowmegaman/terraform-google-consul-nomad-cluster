{
    "bootstrap_expect": ${bootstrap_expect},
    "datacenter": "${datacenter}",
    "encrypt": "${consul_key}",
    "server": ${server_bool},
    "retry_join": ${cloud-auto-join},
    "client_addr": "0.0.0.0",
    "advertise_addr": "{{GetPrivateIP}}",
    "recursors": ["8.8.8.8"],
    "ports": { "dns": 53 },
    "ui": true,
    "leave_on_terminate": true,
    "rejoin_after_leave": true,
    "data_dir": "/var/consul",
    "enable_syslog": true
}
