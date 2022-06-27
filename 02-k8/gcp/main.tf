terraform {
}

locals {
    release_channel    = var.release_channel == "" ? [] : [var.release_channel]
    gcp_region         = var.gcp_location
    identity_namespace = var.identity_namespace == "" ? [] : [var.identity_namespace]
}

provider "google" {
  project     = var.gcp_project_id
  region      = local.gcp_region
  credentials = file("key.json")
}

provider "google-beta" {
  project     = var.gcp_project_id
  region      = local.gcp_region
  credentials = file("key.json")
}

resource "google_container_cluster" "cluster" {
  provider = google-beta

  location = var.gcp_location
  name     = var.cluster_name

  dynamic "release_channel" {
    for_each = toset(local.release_channel)

    content {
      channel = release_channel.value
    }
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = var.stackdriver_logging != "false" ? "logging.googleapis.com/kubernetes" : ""
  monitoring_service = var.stackdriver_monitoring != "false" ? "monitoring.googleapis.com/kubernetes" : ""

  timeouts {
    update = "20m"
  }
}

resource "google_container_node_pool" "node_pool" {
  provider = google

  location = google_container_cluster.cluster.location
  count    = length(var.node_pools)
  name     = format("%s-pool", lookup(var.node_pools[count.index], "name", format("%03d", count.index + 1)))

  cluster            = google_container_cluster.cluster.name
  initial_node_count = lookup(var.node_pools[count.index], "initial_node_count", 1)

  autoscaling {
    max_node_count = lookup(var.node_pools[count.index], "autoscaling_max_node_count", 2)
    min_node_count = lookup(var.node_pools[count.index], "autoscaling_min_node_count", 1)
  }

  management {
    auto_repair  = lookup(var.node_pools[count.index], "auto_repair", true)
    auto_upgrade = lookup(var.node_pools[count.index], "version", "") == "" ? lookup(var.node_pools[count.index], "auto_upgrade", true) : false
  }

  node_config {
    machine_type    = lookup(var.node_pools[count.index], "node_config_machine_type", "g1-small")
    service_account = google_service_account.default.email

    disk_type    = lookup(var.node_pools[count.index], "node_config_disk_type", "pd-standard")
    disk_size_gb = lookup(var.node_pools[count.index], "node_config_disk_size_gb", 10)
    preemptible  = lookup(var.node_pools[count.index], "node_config_preemptible", false)

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
      banana-env               = "non-prod"
    }
  }

  timeouts {
    update = "20m"
  }
}