variable "gcp_pub_key" {
  default = "~/.ssh/proxycannon.pem.pub"
}

variable "gcp_priv_key" {
  default = "~/.ssh/proxycannon.pem"
}

variable "credentials_file_path" {
  default = "~/.gcp/credentials"
}
# launch all exit nodes in the same subnet id
# this should be the same subnet id that your control server is in
# you can get this value from the AWS console when viewing the details of the control-server instance
variable "subnet_id" {
  default = "proxy-cannon"
}
