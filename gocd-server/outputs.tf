// Output url to Go server, needed för agents to connect to.
output "url"
{
	  value = "https://${kubernetes_service.gocd-server.load_balancer_ingress.0.ip}:443"
}
// Hardcoded value, make it more dynamic in the future
output "auto_reg"
{
	  value = "95e0a630-c1ed-4c16-b636-2450b30ec18a"
}
