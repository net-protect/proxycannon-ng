variable "gcp_pub_key" {
  default = "~/.ssh/proxycannon.pem.pub"
}

variable "gcp_priv_key" {
  default = "~/.ssh/proxycannon.pem"
}

variable "credentials_file_path" {
  default = "~/.gcp-credentials/proxy-cannon-1337-160d2bec8243.json"
}
/*
# number of exit-node instances to launch
variable "count" {
  default = 2
}
*/

# launch all exit nodes in the same subnet id
# this should be the same subnet id that your control server is in
# you can get this value from the AWS console when viewing the details of the control-server instance
variable "subnet_id" {
  default = "subnet-XXXXXXXX"
}
