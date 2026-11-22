variable "image" {
  description = "Docker image to run (built in exercise 2.1)"
  type        = string
  default     = "orders-api:1.1"
}

variable "container_name" {
  description = "Name of the app container"
  type        = string
  default     = "orders-web"
}

variable "external_port" {
  description = "Port on your machine"
  type        = number
  default     = 8080
}

variable "network_name" {
  description = "Docker network shared by app and db"
  type        = string
  default     = "orders-net"
}

variable "volume_name" {
  description = "Named volume for Postgres data"
  type        = string
  default     = "orders-data"
}

variable "db_container_name" {
  description = "Name (and network alias) of the Postgres container"
  type        = string
  default     = "db"
}

variable "db_name" {
  description = "Postgres database name"
  type        = string
  default     = "orders"
}

variable "db_password" {
  description = "Postgres password (dev only)"
  type        = string
  default     = "devpass"
  sensitive   = true
}
