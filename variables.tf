variable "cluster_name" {
  type    = string
  default = "mycluster"
}

variable "kube_version" {
  type    = string
  default = "1.25.3"
}

variable "num_of_servers" {
  type    = number
  default = 1
}

variable "num_of_agents" {
  type    = number
  default = 1
}

variable "kubeconfig_path" {
  type = string
  default = "local-k8s-config"
}

