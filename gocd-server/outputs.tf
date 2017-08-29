// Output url to Go server, needed för agents to connect to.
output "url"
{
	  value = "https://${kubernetes_service.gocd-server.load_balancer_ingress.0.ip}:443"
}
