variable "topics" {
  description = "topics templates"
  type = map(object({
    name       = string
    namespace  = string
    cluster    = string
    partitions = number
    replicas   = number
    config     = map(string)
  }))
  
}