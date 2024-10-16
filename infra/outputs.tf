# output "three-tier-app-frontend-load-balancer" {
#   value = module.three-tier-app-frontend-lb.load_balancer_ip
#   description = "Frontend load balancer endpoint"
# }

output "lb-ip" {
  value = module.three-tier-app-backend-lb.external_ip
  description = "Backend load balancer endpoint"
}