# Instance specification
# todo: specify availability_type
resource "google_sql_database_instance" "replica_name" {
    count = var.read_replicate ? 1 : 0
    name = "${var.instance_name_without_version}-14-replica"
    region = var.region
    database_version = var.engine_version
    master_instance_name = google_sql_database_instance.master.name
    deletion_protection = "true"

    # instance specification / instance settings
    settings {
        tier = var.read_replica_instance_class
        disk_autoresize = var.disk_autoresize

        user_labels = {
          is_production = var.is_production
          repository = var.repository
        }
    }
}