variable "region" {
  default = "eu-west-1"
}

variable "cluster_name" {
  default = "otus-project"
  type    = string
}

variable "subnet_cidr_db" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "cluster_version" {
  description = "Cluster Version"
  default     = "1.16"
}