resource "helm_release" "strimzi" {
  name       = "strimzi"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  version    = "0.44.0"
  namespace  = "kafka"
  create_namespace = true
  values = [
    file("${path.module}/strimzi/strimzi-values.yaml")
  ]

}

resource "kubernetes_manifest" "cluster_kafka_zookeeper" {
    depends_on = [ helm_release.strimzi ]
    count = var.create_kafka_cluster_with_zookeeper ? 1 : 0
    manifest = {
        apiVersion = "kafka.strimzi.io/v1beta1"
        kind = "Kafka"
        metadata = {
            name = "my-cluster"
            namespace = "kafka"
        }
        spec = {
            kafka = {
            replicas = 3
            listeners = {
                plain = {}
                tls = {}
            }
            config = {
                offsets_topic_replication_factor = 3
                transaction_state_log_replication_factor = 3
                transaction_state_log_min_isr = 2
            }
            }
            zookeeper = {
            replicas = 3
            }
            entityOperator = {
            topicOperator = {}
            userOperator = {}
            }
        }
    }


}

resource "kubernetes_manifest" "controller_kafka" {
    depends_on = [ helm_release.strimzi ]
    count = var.create_kafka_cluster_without_zookeeper ? 1 : 0
    manifest = {
        apiVersion = "kafka.strimzi.io/v1beta2"
        kind = "KafkaNodePool"
        metadata = {
            name = "my-cluster"
            namespace = "kafka"
            labels = {
                "strimzi.io/cluster" = "my-cluster"
            }
        }
        spec = {
            replicas = 3
            roles = ["controller"]
            storage = {
                type = "jbod"
                volumes = [
                    {
                        id = 0
                        type = "persistent-claim"
                        size = "100Gi"
                        kraftMetadata = "shared"
                        deleteClaim = false

                    }
                ]

        }

    }

}

}

resource "kubernetes_manifest" "broker_kafka" {
    depends_on = [ helm_release.strimzi ]
    count = var.create_kafka_cluster_without_zookeeper ? 1 : 0
    manifest = {
        apiVersion = "kafka.strimzi.io/v1beta2"
        kind = "KafkaNodePool"
        metadata = {
            name = "my-cluster"
            namespace = "kafka"
            labels = {
                "strimzi.io/cluster" = "my-cluster"
            }
        }
        spec = {
            replicas = 3
            roles = ["broker"]
            storage = {
                type = "jbod"
                volumes = [
                    {
                        id = 0
                        type = "persistent-claim"
                        size = "100Gi"
                        kraftMetadata = "shared"
                        deleteClaim = false

                    }
                ]

        }

    }

}

}

resource "kubernetes_manifest" "cluster_kafka_without_zookeeper" {
  depends_on = [helm_release.strimzi]
  count      = var.create_kafka_cluster_without_zookeeper ? 1 : 0

  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "Kafka"
    metadata = {
      name        = "my-cluster"
      namespace   = "kafka"
      annotations = {
        "strimzi.io/node-pools" = "enabled"
        "strimzi.io/kraft"      = "enabled"
      }
    }
    spec = {
      kafka = {
        version         = "3.8.0"
        metadataVersion = "3.8-IV0"
        listeners = [
          {
            name = "plain"
            port = 9092
            type = "internal"
            tls  = false
          },
          {
            name = "tls"
            port = 9093
            type = "internal"
            tls  = true
          }
        ]
        config = {
          "offsets.topic.replication.factor"         = 3
          "transaction.state.log.replication.factor" = 3
          "transaction.state.log.min.isr"            = 2
          "default.replication.factor"               = 3
          "min.insync.replicas"                      = 2
        }
      }
      entityOperator = {
        topicOperator = {}
        userOperator  = {}
      }
    }
  }
}
