provider "random" {
}

resource "random_id" "entropy" {
    byte_length = 6
}

resource "google_service_account" "default" {
    provider = google

    account_id = "cluster-minimal-${random_id.entropy.hex}"
    display_name = "Minimal service account for GKE cluster ${var.cluster_name}"
    project = var.gcp_project_id
}