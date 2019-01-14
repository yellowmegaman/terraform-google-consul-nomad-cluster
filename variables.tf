variable "datacenter"   {
	description = "The name of the datacenter to user for Consul/Nomad"
}
variable "tag"          {
	description = "Tag name to use for Google Compute Engine instances, used for cloud auto-join discovery"
}
variable "mode"         {
	description = "server/client mode to use. Applies both to Consul and Nomad"
}
variable "nomad-dense"  {
	default     = "true"
	description = "Whenever to allow running Nomad client alongside Nomad server. Not recommended in production by Hashicorp"
}
variable "count"        {
	description = "Instance count"
}
variable "machine_type" {
	default     = "n1-standard-2"
	description = "Instance machine type"
}
variable "zone"         {
	default     = "europe-west3-a"
	description = "Google Compute Engine zone to launch instances in"
}
variable "disk_image"   {
	description = "Disk image with consul/nomad service files and binaries. See https://github.com/yellowmegaman/golden-image"
}
variable "disk_size"    {
	default     = "15"
	description = "Insance disk size"
}
variable "disk_type"    {
	default     = "pd-ssd"
	description = "Instance disk type. Can be pd-standard or pd-ssd"
}
variable "scopes"       {
	default     = ["compute-ro"]
	description = "List of scopes. compute-ro is needed for cloud auto-discovery"
}
variable "network_tags" {
	default     = ["ssh-wan"]
	description = "Instance network tags"
}
variable "ssh_user"     {
	default     = "cloud"
	description = "SSH username to use for provisioning"
}
variable "ssh_key"    {
	description = "Private key for file/shell provisioner for your instances"
}
variable "consul_key"   {
	description = "Consul encryption key. Can be obtained with `consul keygen` command"
}
variable "cmd"          {
	default     = ""
	description = "Any additional command you might want to run at server creation time"
}
