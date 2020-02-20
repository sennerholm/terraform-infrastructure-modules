output "external_ip" {
  value = kubernetes_service.vote-front.load_balancer_ingress[0].ip 
}

output "dns" {
  value = cloudflare_record.vote-front.hostname
}
