output "url" {
  description = "Open this in the browser"
  value       = "http://localhost:${var.external_port}"
}

output "network" {
  description = "Docker network name"
  value       = docker_network.app.name
}

output "volume" {
  description = "Postgres data volume name"
  value       = docker_volume.orders_data.name
}

output "database_url" {
  description = "Connection string used by the app (inside the Docker network)"
  value       = "postgres://postgres:${var.db_password}@${var.db_container_name}:5432/${var.db_name}"
  sensitive   = true
}
