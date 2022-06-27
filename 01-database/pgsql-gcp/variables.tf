# Env spec
variable "instance_name_without_version" {
}

variable "region" {
}

variable "is_production" {
}

variable "engine_version" {
}

variable "instance_class" {
}

variable "read_replica_instance_class" {
}

variable "allocated_storage" {
}

variable "disk_autoresize" {
}

variable "master_password" {
}

variable "repository" {
}

variable "project" {
}

variable "high_available" {
}


variable "map_env" {
  type        = map(string)
  description = "is_production -> db label text"

  default = {
    1 = "prod"
    0 = "non-prod"
  }
}

variable "read_replica" {
  default = true
}

variable "map_availability_type" {
  type        = map(string)
  description = "high_available -> availability_type"

  default = {
    "0" = "ZONAL"
    "1" = "REGIONAL"
  }
}

# Instance specification
variable "map_major_version" {
  type = map(string)

  default = {
    "POSTGRES_14" = "POSTGRES_14"
  }
}

variable "zone" {
  default = "us-central1-b"
}

variable "transaction_log_retention_days" {
  default = 1
}

# Instance specification / master user settings
variable "master_username" {
}

# Instance specification / network & security
variable "private_network" {
}

# Instance specification / database options
variable "db_name" {
}

# Instance specification / backup
variable "backup_time" {
}

# instance specification /maintenance
variable "maintenance_windows_day" {
  description = "update_track - (Optional) Receive updates earlier (canary) or later (stable)"
  default     = "stable"
}

variable "maintenance_window_hour" {
  description = "Hour - (Optional) Hour of day (0-23), ignored if day not set"
  default     = "02"
}

variable "maintenance_update_track" {
  description = "Day - (Optional) Day of week (1-7), starting on Monday"
  default     = "1"
}

# parameters / connections and authentication
variable "map_max_connections" {
  type        = map(string)
  description = "Instance class -> max_connections"

  default = {
    # shared-core machines (fixed)
    "db-f1-micro" = "10"
    "db-g1-small" = "20"

    # Custom machines (1 GB RAB -> 100 connections)
    "db-custom-1-3840" = "384"
  }
}

# parameters / resource usage (except wal)
variable "map_work_mem" {
  type        = map(string)
  description = "Instance class -> work_mem (KB)"

  default = {
    # Shared-core machines (1% of ram)
    "db-f1-micro" = "629146"
    "db-g1-small" = "1782579"
    # Custom machines (1% of ram)
    "db-custom-1-3840" = "3932160"
  }
}

variable "parameter_vacuum_cost_limit" {
  default = "2000"
}

# parameters / write ahead log
variable "parameter_checkpoint_timeout" {
  default = "300" # seconds
}

variable "parameter_max_wal_size" {
  default = "192" # 2GB
}

# parameters / replication
variable "parameter_max_standby_streaming_delay" {
  default = "3000" # 30 s
}

# parameters / query tuning
variable "parameter_random_page_cost" {
  default = "1.1"
}

# parameters / runtime statistics
variable "parameter_track_io_timing" {
  default = "off"
}

# parameters / autovacuum
variable "parameter_log_autovacuum_min_duration" {
  default = "0"
}

# Parameters / custom
variable "parameter_pg_stat_statements_track" {
  default = "all"
}

variable "parameter_track_activity_query_size" {
  default = "2064"
}

variable "parameter_autovacuum_vacuum_threshold" {
  default = "100"
}

variable "parameter_autovacuum_analyze_threshold" {
  default = "100"
}

variable "parameter_autovacuum_scale_factor" {
  default = "0.05"
}