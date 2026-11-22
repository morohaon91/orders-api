terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# --- Network & volume (mirrors compose.yaml) ---

resource "docker_network" "app" {
  name = var.network_name
}

resource "docker_volume" "orders_data" {
  name = var.volume_name
}

# --- Database (postgres:16-alpine) ---

resource "docker_image" "db" {
  name         = "postgres:16-alpine"
  keep_locally = true
}

resource "docker_container" "db" {
  name  = var.db_container_name
  image = docker_image.db.image_id

  env = [
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]

  volumes {
    volume_name    = docker_volume.orders_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app.name
    aliases = [var.db_container_name]
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U postgres"]
    interval = "5s"
    retries  = 5
  }
}

# --- App ---

resource "docker_image" "app" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "web" {
  name  = var.container_name
  image = docker_image.app.image_id

  env = [
    "DATABASE_URL=postgres://postgres:${var.db_password}@${var.db_container_name}:5432/${var.db_name}",
  ]

  ports {
    internal = 3000
    external = var.external_port
  }

  networks_advanced {
    name = docker_network.app.name
  }

  depends_on = [docker_container.db]
}
