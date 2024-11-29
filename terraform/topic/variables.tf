

variable "namespace" {
  description = "namespace where the topics will be created"
  default = "kafka"
}

variable "create_namespace" {
  description = "create the namespace if it does not exist"
  default = false
}

variable "values" {
  description = "values to be passed to the helm chart"
  default = {}
}