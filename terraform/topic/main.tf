resource "helm_release" "topics" {
    name = var.topics["name"]
    chart = "../charts/topics"
    namespace = var.namespace
    create_namespace = var.create_namespace
    values = var.values
}