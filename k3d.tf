
resource "k3d_cluster" "cluster" {
  name    = var.cluster_name
  servers = var.num_of_servers
  agents  = var.num_of_agents

  image = "rancher/k3s:v${var.kube_version}-k3s1"

  port {
    host_port      = 80
    container_port = 80
    node_filters = [
      "loadbalancer",
    ]
  }

  kube_api {
    host      = "localhost"
    host_ip   = "0.0.0.0"
    host_port = 6443
  }

  registries {
    use = [
      "k3d-registry.localhost:12345"
    ]
    config = <<EOF
mirrors:
  "k3d-registry.localhost:12345":
    endpoint:
      - http://k3d-registry.localhost:5000
EOF
  }

  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

  k3s {
    extra_args {
      arg = "--disable=traefik"
      node_filters = [
        "server:*",
      ]
    }
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOD
cat <<EOF > ${var.kubeconfig_path}
${k3d_cluster.cluster.credentials[0].raw}
EOF
EOD
  }
}

resource "k3d_registry" "mycluster-registry" {
  name = "registry.localhost"
  port {
      host = "registry.localhost"
      host_ip = "127.0.0.1"
      host_port = "12345"
  }
}
