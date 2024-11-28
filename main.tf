# Provider configuration
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.60.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-key.json")
  project     = "xen-web"
  region      = "us-central1"
}

# Static IP address
resource "google_compute_address" "xen_web_static_ip" {
  name = "xen-web-static-ip"
}

# VM instance to host CakePHP
resource "google_compute_instance" "xen_web_vm" {
  name         = "xen-web-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["webhook-server"]

    network_interface {
    network    = "default"
    access_config {}
  }

  boot_disk {
    source = "projects/xen-web/zones/${var.region}-a/disks/xen-web-instance"
  }

  metadata = {
    startup-script = <<EOT
#!/bin/bash
apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mysql unzip
systemctl enable apache2
systemctl start apache2
EOT

    ssh-keys = <<EOT
gcp:ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBTBc3zmnyQig1aPdQFRlioTtGjTTkmGqAGEQqKD+7TwufKBu1M98OWo618nYHKnQ9ych0TN7upslcgCEsSBB/4= google-ssh {"userName":"gcp@garnetcs.com","expireOn":"2024-11-25T22:46:39+0000"}
gcp:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsp/iDhcPYd/UhpPtA9eOxJWwn8Ew0LCdTVmqhpgubS67x9EnaAJxRXHLWk9M0CEpFg2kVgRZX2SvV27DmZYqylv8BuoDKuGVFRTMAyOxg92Kr7AMmHl+/BiXm6wfPT3dkg5VNPLARvPz/yZw/1UqGRM0crMM+t2ofVaaATdlJk6PVb3yHxEJrLCMz1afdm6jabrbpKc2LDiA45SuvshcJT4Q7jI9l13yBzi49JUWg7UMKQi5JmujD5HmHGawbTbH6N6dPi7FxMyBMfnvc7hMlXAmXI7ddGGhs5kbT4iTihs9wVUo6kH6BK5sfiSD/FaYY3qjYhAi943IihWZiw6pj google-ssh {"userName":"gcp@garnetcs.com","expireOn":"2024-11-25T22:46:42+0000"}
gcp:ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFZ4/Lxrrt0NRBpinnE7OHrG2NmkO7qa8j/7w02/Noa9qKpNzjeaj3aegLhhw6HTAMhXslWHMdXgrXY/86iNxoM= google-ssh {"userName":"gcp@garnetcs.com","expireOn":"2024-11-25T22:47:05+0000"}
gcp:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAEhPfCT2PQPxK00WlUR9yu4+eGoac/0Wt66GjWt5Dl7A3vzWy993IztVS8y0XVWTI3qU8MIFpsHDM8a5vEydS4RD+OvVUX3A8FCerm/He6NOK8a9NE+0w5g8Ced3J0Bs1Asv16PfkZgfMCUB1oOI0Aaahs0xxAlJukD6xyHdnJ5j4D5b6nu+uDLZzMTogCK3YQX4f2LXjQgQpcWFv/hp3npPkUNkL9Jci6ybGT0thu2BfDPU4zEZwI0oxNnA9iCeHYJkTQ10nM3zJhuaVr516Rnue3E17734AgqihBtkNh8PQ9fj4QpG/7jnwu1XYTzNLe5whv7z3anaYf+bZnNgDeU= google-ssh {"userName":"gcp@garnetcs.com","expireOn":"2024-11-25T22:47:11+0000"}
gcp:ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPUeyH4zqHDnuAFM8LjxPyNQmDKt2Jtz/rYE50xG6TQb2jjqazMJ24WwauLsVT97/djJa+tPWmg1gVO2mZeH5zk= google-ssh {"userName":"gcp@garnetcs.com","expireOn":"2024-11-25T22:48:55+0000"}
gcp:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCi6PnlTZWF9y7IoGZrVVcwmhAQMEvaT5mA96+F2GPi9sh/FXbhlO/EYuys7N3asD1mHbzJ1a2Gvj2kfhx7Yq4KqhY5IeEAqEB4wJLQ+OsFVq9loZZ4FeJvI48qZd0QQldTKGE8MAVMfz66+l5nfAKfyVKEI1IfYxh3V0m0ljVvykmM3s/PBISYdbo3vjphKjy8uX8lNsbggXN0Smhv3JlgNpDqcA9uCLCQa5UUh3WufNwA0rvjPHT32htrNHKDxbGVDVAks+6ot1g8WcTje51zjlk/asUsklcoPaV8HXk8h0bF5hj5Udo2AOXNwByhR7FMmwt/JwMB2QJM+rl3NCG5 google-ssh {"userName":"gcp@garnetcs.com","expireOn":"2024-11-25T22:48:59+0000"}
EOT
  }

  lifecycle {
    ignore_changes = all
  }
}


# Cloud Storage bucket for static assets
resource "google_storage_bucket" "xen_web_bucket" {
  name          = "xen-web-static-bucket"
  location      = "US"
  force_destroy = true
}

# Assign IAM role for the bucket
resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = google_storage_bucket.xen_web_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:terraform-sa@xen-web.iam.gserviceaccount.com"
}

# Outputs
output "static_ip" {
  value = google_compute_address.xen_web_static_ip.address
}

output "bucket_name" {
  value = google_storage_bucket.xen_web_bucket.name
}

module "workstations" {
  source     = "./workstations"
  project_id = var.project_id
  region     = var.region
}
