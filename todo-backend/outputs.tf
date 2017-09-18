output "url"
{
	  value = "http://${kubernetes_service.todo_backend.load_balancer_ingress.0.ip}"
}

output "google_datastore_namespace" {
    value = "${kubernetes_namespace.todo_backend.metadata.0.name}"
}