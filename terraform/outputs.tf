output "load_balancer_ip" {
  value = module.nginx.lb_ip
}

output "bastion_ssh_command" {
  value = "gcloud compute ssh ${module.bastion.instance_name} --zone=${var.region}-a --tunnel-through-iap"
}

output "tomcat_private_ips" {
  value = module.tomcat.instance_ips
}