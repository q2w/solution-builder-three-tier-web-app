output "three-tier-app-frontend-load-balancer" {
  value = module.three-tier-app-frontend-lb.load_balancer_ip
  description = "Frontend load balancer endpoint"
}
