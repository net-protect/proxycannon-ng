provider "google" {
  credentials = file(var.credentials_file_path)
  project = "proxy-cannon-1337"
  region  = "us-central1"
  zone    = "us-central1-a"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

resource "google_compute_instance" "exit-node" {
  count        = var.instance_count
  name         = "exitnode-${count.index}"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["exit-node"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240426"
    }
  }

  network_interface {
    network = "proxy-cannon"
    subnetwork = "proxy-cannon-central"
    access_config {
      // Ephemeral IP
    }
  }

    metadata = {
    ssh-keys = "proxycannon:${file(var.gcp_pub_key)}"
  }

  # upload our provisioning scripts
  provisioner "file" {
    source      = "${path.module}/configs/"
    destination = "/tmp/"

    connection {
      type     = "ssh"
      user     = "proxycannon"
      private_key = "${file("${var.gcp_priv_key}")}"
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  # execute our provisioning scripts
  provisioner "remote-exec" {
    script = "${path.module}/configs/node_setup.bash"

    connection {
      type     = "ssh"
      user     = "proxycannon"
      private_key = "${file("${var.gcp_priv_key}")}"
      host        = self.network_interface[0].access_config[0].nat_ip
      
    }
  }
  /*
  # modify our route table when we bring up an exit-node
  provisioner "local-exec" {
    command = "sudo ./add_route.bash ${self.private_ip}"
  }

  # modify our route table when we destroy an exit-node
  provisioner "local-exec" {
    when = "destroy"
    command = "sudo ./del_route.bash ${self.private_ip}"
  }
  */

}

resource "google_compute_firewall" "exit-node-sec-group" {
  name    = "exit-node-sec-group"
  network = "proxy-cannon"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
}