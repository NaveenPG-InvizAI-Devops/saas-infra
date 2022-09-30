data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke1.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke1.ca_certificate)
}





module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1, < 5.0.0"

  project_id   = var.project_id
  network_name = var.network

  subnets = [
    {
      subnet_name           = var.subnetwork1
      subnet_ip             = "10.0.0.0/17"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = var.subnetwork2
      subnet_ip             = "10.6.0.0/17"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    (var.subnetwork1) = [
      {
        range_name    = var.ip_range_pods
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = var.ip_range_services
        ip_cidr_range = "192.168.64.0/18"
      },
    ],
  
    (var.subnetwork2) = [
      {
        range_name    = var.ip_range_pods2
        ip_cidr_range = "193.168.0.0/18"
      },
      {

        range_name    = var.ip_range_services2
        ip_cidr_range = "193.168.64.0/18"
      },
    ]
  
  }
  
}

module "gke1" {

  source     = "terraform-google-modules/kubernetes-engine/google"
  version    = "20.0.0"
  project_id = var.project_id
  name       = var.cluster_name1
  regional   = true
  region     = var.region
  zones      = slice(var.zone, 0, 1)
  
  network                 = module.gcp-network.network_name
  // subnetwork           = module.gcp-network.subnets_names
  subnetwork              = var.subnetwork1 
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  create_service_account  = false
  // cluster_ipv4_cidr       = "172.16.0.0/28"
  release_channel         = "STABLE"
  cluster_autoscaling     = var.cluster_autoscaling

 
  network_policy = true


  node_pools             = [
    {
      name            = "pool-01"
      min_count       = 1
      max_count       = 10
      machine_type    = "e2-standard-2"
      // service_account = var.compute_engine_service_account
      auto_upgrade    = true
    },{}

  ]
  
  depends_on =[module.gcp-network]
}



module "sql-db_example_postgresql-public" {
  source  = "GoogleCloudPlatform/sql-db/google//examples/postgresql-public"
  #version = "12.0.0"
  authorized_networks= var.authorized_networks
  db_name="testingv1"
  project_id=var.project_id
  
  }

  /*module "sql-db_example_postgresql-public" {
  source  = "GoogleCloudPlatform/sql-db/google//examples/postgresql-public"
  #version = "12.0.0"


  
  name                 = var.db_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = var.zone
  region               = var.region
  tier                 = "db-custom-1-3840"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }
}*/


module "memstore" {
  source = "./memstore"

  name = "saas-redis"

  project                 = var.project_id
  region                  = var.region
  location_id             = "asia-south1-a"
  alternative_location_id = "asia-south1-b"
  enable_apis             = true
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  authorized_network      = module.gcp-network.network_name
  memory_size_gb          = 6
}

/*
module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.8"

  topic        = "var.topic_name"
  create_topic = true
  project_id   = var.project_id

  pull_subscriptions = [
    {
      name                    = "sub_name"
      ack_deadline_seconds    = 10
    }
  ]

  topic_labels  = {
    app = "l1"
  }

  subscription_labels = {
    app = "l1"
  }
}

*/
resource "google_pubsub_topic" "test" {
    name ="test"
    project = var.project_id
}


resource "google_pubsub_subscription" "test_sub" {
    name="test-subscriber"
    project=var.project_id
    topic="${google_pubsub_topic.test.name}"
}