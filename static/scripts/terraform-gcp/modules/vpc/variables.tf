variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "node_subnet_name" {
  description = "The node subnet name"
  type        = string
}

variable "ip_cidr_range" {
  description = "The subnet ip range to setup"
  type        = string
}
