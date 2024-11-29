resource "helm_release" "strimzi" {
  name             = "strimzi"
  repository       = "https://strimzi.io/charts/"
  chart            = "strimzi-kafka-operator"
  version          = "0.44.0"
  namespace        = "kafka"
  create_namespace = true
  values = [
    file("${path.module}/strimzi/strimzi-values.yaml")
  ]

}

resource "helm_release" "cluster-kraft" {
  depends_on       = [helm_release.strimzi]
  count            = var.create_kafka_cluster_without_zookeeper ? 1 : 0
  name             = "kafka"
  chart            = "../../charts/cluster-kraft"
  version          = "1.0.0"
  namespace        = "kafka"
  create_namespace = false
  values = [
    file("${path.module}/cluster-values/values.yaml")
  ]

}