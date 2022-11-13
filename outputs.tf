output "local_k8s_config" {
  value = k3d_cluster.cluster.credentials[0].raw
  sensitive = true
}

