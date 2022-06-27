provider "google" {
    project = var.project
    region = var.region
    credentials = file("key.json")
}

provider "google-beta" {
    region = var.region
    zone = var.zone
}

locals {
    # Must be changed to firewalled rules
    external_allowance = ["0.0.0.0/0"]
}

# Instance specification
resource "google_sql_database_instance" "master" {
    name = "${var.instance_name_without_version-14-master}"
    region = var.region
    database_version = var.engine_version
    deletion_protection = true

    # Instance specification / instance settings
  settings {
        tier = var.instance_class
        availability_type = var.map_availability_type[var.high_available]
        disk_size = var.allocated_storage
        disk_autoresize = var.disk_autoresize

        user_labels = {
          env = var.map_env[var.is_production]
          repository = var.repository
        }

        ip_configuration {
          ipv4_enabled = true

          dynamic "authorized_networks" {
              # external connections
              for_each = local.external_allowance
              iterator = external_allowance

              content {
                  name = "external-${external_allowance.key}"
                  value = external_allowance.value
                  expiration_time = "3021-11-15T16:19:00.094Z"
              }
          }
        }

        # instance specification / backups | why backup from master?
        backup_configuration {
            enabled = var.is_production == 0 ? false : true
            start_time = var.backup_time
            transaction_log_retention_days = var.transaction_log_retention_days
        }

        # instance specification / maintenance
        maintenance_window {
            day = var.maintenance_window_day
            hour = var.maintenance_window_hour
            update_track = var.maintenance_update_track
        }

        database_flags {
            name = "max_connections"
            value = var.map_max_connections[var.instance_class]
        }
    }
}

resource "google_sql_database" "database" {
    name = var.db_name
    instance = google_sql_database_instance.master.name
    lifecycle {
        prevent_destroy = "1"
    }
}

resource "google_sql_user" "master" {
    name = var.master_username
    password = var.master_password
    instance = google_sql_database_instance.master.name
}