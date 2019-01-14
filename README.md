# Consul and Nomad cluster on Google Cloud Engine (GCE)

This repo is a terraform module for Consul/Nomad cluster. Can be used directly in terraform. 

Requirements: disk image with consul/nomad binaries and systemd service files. See how to create one using Packer -  https://github.com/yellowmegaman/golden-image

Usage

```
module "ci-servers" {
  source       = "github.com/yellowmegaman/terraform-google-consul-nomad-cluster"
  datacenter   = "leet"
  tag          = "mytag"
  ssh_user     = "cloud"
  ssh_key      = "${var.CLOUD_SSH}"
  consul_key   = "${var.CONSUL_KEY}"
  count        = "3"
  mode         = "server"
  nomad-dense  = "false"
  disk_image   = "<my image with consul/nomad binaries and systemd service files>"
}

module "ci-clients" {
  source       = "github.com/yellowmegaman/terraform-google-consul-nomad-cluster"
  datacenter   = "leet"
  tag          = "mytag"
  ssh_user     = "cloud"
  ssh_key      = "${var.CLOUD_SSH}"
  consul_key   = "${var.CONSUL_KEY}"
  count        = "2"
  mode         = "client"
  nomad-dense  = "false"
  disk_image   = "<my image with consul/nomad binaries and systemd service files>"
}

variable "CONSUL_KEY" {}
variable "CLOUD_SSH"  {}
```

Configuration above will:
- spawn 3 servers and 2 clients in GCE
- generate Consul/Nomad configuration
- auto-join Consul/Nomad using cloud tag and compute-ro scope
- execute optional command (if needed)

## What to look for:
Variables `ssh_user` and `ssh_key` are pretty much the most important here, since those values should be already in your GCE project metadata for provisioners to work. 
If you got stuck at creation time on connection steps, that means you probably supplied wrong credentials here.

Example above complies with Hashicorp documentation in not running Nomad client alongside with server, you can override it by simply setting `nomad-dense` to `true`.
