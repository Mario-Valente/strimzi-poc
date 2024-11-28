variable "create_kafka_cluster_with_zookeeper" {
  default = false
}

variable "create_kafka_cluster_without_zookeeper" {
  default = true
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  default     = "~/.kube/config"

}

