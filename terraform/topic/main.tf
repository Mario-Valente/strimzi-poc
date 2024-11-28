resource "kubernetes_manifest" "this" {
    for_each = var.topics
    manifest = {
        apiVersion = "kafka.strimzi.io/v1beta2"
        kind       = "KafkaTopic"
        metadata = {
            name      = each.value.name
            namespace = each.value.namespace
            labels = {
                "strimzi.io/cluster" = each.value.cluster
            }
        }
        spec = {
            partitions = each.value.partitions
            replicas   = each.value.replicas
            config = each.value.config
        }
    }
}