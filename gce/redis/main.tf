resource "google_redis_instance" "main" {
  name               = substr(lower("redis${var.region}${var.env}${var.system}${var.component}${var.append_name}"),0,39)
  memory_size_gb = 1
}
