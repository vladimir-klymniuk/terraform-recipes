variable "gcp_project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "gcp_location" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "daily_maintenance_window_start_time" {
  type = string
}

variable "node_pools" {
  type = list(map(string))
}

variable "vpc_network_name" {
  type = string
}

variable "vpc_subnetwork_name" {
  type = string
}

variable "private_endpoint" {
  type    = bool
  default = false
}

variable "private_nodes" {
  type    = bool
  default = true
}

variable "enable_cloud_nat" {
  type    = bool
  default = true
}

variable "enable_cloud_nat_logging" {
  type    = bool
  default = true
}

variable "cloud_nat_logging_filter" {
  type    = string
  default = "ERRORS_ONLY"
}

variable "vpc_subnetwork_cidr_range" {
  type = string
}

variable "cluster_secondary_range_name" {
  type = string
}

variable "cluster_secondary_range_cidr" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
}

variable "services_secondary_range_cidr" {
  type = string
}

# k8s local network
variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28"
}

variable "access_private_images" {
  type    = bool
  default = false
}

variable "http_load_balancing_disabled" {
  type    = bool
  default = false
}

#TODO update with firewall
variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))

  default = [
    {

      cidr_block   = "0.0.0.0/0"
      display_name = "default"
    },
  ]
}

variable "pod_security_policy_enabled" {
  type    = bool
  default = false
}

variable "identity_namespace" {
  type = string
}

variable "enable_private_nodes" {
  type    = bool
  default = true
}

variable "stackdriver_logging" {
  type    = bool
  default = false
}

variable "stackdriver_monitoring" {
  type    = bool
  default = false
}

variable "release_channel" {
  type    = string
  default = "REGULAR"
}