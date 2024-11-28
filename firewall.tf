# Rule: allow-http-https
resource "google_compute_firewall" "allow_http_https" {
  name          = "allow-http-https"
  network       = "default"
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

# Rule: allow-webhook-port
resource "google_compute_firewall" "allow_webhook_port" {
  name          = "allow-webhook-port"
  network       = "default"
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }
}

# Rule: default-allow-ssh
resource "google_compute_firewall" "default_allow_ssh" {
  name          = "default-allow-ssh"
  network       = "default"
  priority      = 65534
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
