variable "project_id" {
  description = "The project ID to host the cluster in"
  default="inviz-gcp"
}

variable "cluster_name1" {
  description = "The name for the GKE cluster"
  default     = "saas-gke-cluster1"
}

variable "cluster_name2" {
  description = "The name for the GKE cluster"
  default     = "gke-demo-cluster2"
}


variable "region" {
  description = "The region to host the cluster in"
  default     = "asia-south1"
}

variable "region2" {
  description = "The region to host the cluster in"
  default     = "us-west1"
}


variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork1" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet1"
}

variable "subnetwork2" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet2"
}


variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_pods2" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods2"
}


variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-scv"
}

variable "ip_range_services2" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-scv2"
}

variable "zone" {
  type        = list(string)
  default     = ["asia-south1-a","asia-south1-b"]
  description = "The zone to host the cluster in (required if is a zonal cluster)"
}

variable "zones2" {
  type        = list(string)
  default     = ["us-west1-a","us-west1-b"]
  description = "The zone to host the cluster in (required if is a zonal cluster)"
}


variable "db_name" {
  type        = string
  description = "potgresdb name"
  default     = "saas-postgres"
}

variable "topic_name" {
  description = "potgresdb name"
  default     = "saas-topic"
}


variable "cluster_autoscaling" {

  default = {
    enabled             = true
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 10
    min_cpu_cores       = 2
    max_memory_gb       = 1000
    min_memory_gb       = 2
    gpu_resources       = []
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "0.0.0.0/0"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

