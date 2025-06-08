# ----------------------------
# 1. PROVIDER CONFIGURATION
# ----------------------------
provider "google" {
  project = var.gcp_project_id
  region  = var.region
}

# ----------------------------
# 2. NETWORK TIER (VPC, Subnets, Firewall)
# ----------------------------
module "network" {
  source = "./modules/network"

  gcp_project_id = var.gcp_project_id
  region         = var.region
  vpc_name       = "java-app-vpc"
  public_subnet  = "192.168.1.0/24"
  private_subnet = "192.168.2.0/24"
}

# ----------------------------
# 3. DATABASE TIER (Cloud SQL MySQL)
# ----------------------------
module "database" {
  source = "./modules/database"

  gcp_project_id = var.gcp_project_id
  region         = var.region
  vpc_network    = module.network.vpc_name
  db_name        = "javadb"
  db_user        = "admin"
  db_password    = var.db_password  # Passed via TF_VAR_db_password or secrets
}

# ----------------------------
# 4. APPLICATION TIER (Tomcat on Compute Engine)
# ----------------------------
module "tomcat" {
  source = "./modules/tomcat"

  gcp_project_id      = var.gcp_project_id
  region              = var.region
  zone                = "${var.region}-a"
  subnet              = module.network.private_subnet_name
  vpc_name            = module.network.vpc_name
  db_host             = module.database.private_ip
  service_account_email = google_service_account.tomcat.email
  ssh_source_ranges   = ["${module.bastion.public_ip}/32"]  # Only allow SSH from Bastion
}

# ----------------------------
# 5. FRONTEND TIER (NGINX + Load Balancer)
# ----------------------------
module "nginx" {
  source = "./modules/nginx"

  gcp_project_id     = var.gcp_project_id
  region             = var.region
  vpc_name           = module.network.vpc_name
  public_subnet_name = module.network.public_subnet_name
  tomcat_ips         = module.tomcat.instance_ips
}

# ----------------------------
# 6. BASTION HOST (Secure SSH Access)
# ----------------------------
module "bastion" {
  source = "./modules/bastion"

  gcp_project_id     = var.gcp_project_id
  region             = var.region
  zone               = "${var.region}-a"
  vpc_name           = module.network.vpc_name
  public_subnet_name = module.network.public_subnet_name
}

# ----------------------------
# 7. SERVICE ACCOUNT FOR TOMCAT
# ----------------------------
resource "google_service_account" "tomcat" {
  account_id   = "tomcat-service-account"
  display_name = "Service Account for Tomcat Instances"
}

# Grant Cloud SQL Client role
resource "google_project_iam_member" "tomcat_sql" {
  project = var.gcp_project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.tomcat.email}"
}