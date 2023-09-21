
variable "queue_name" {
    description = "name of the queue"
}

variable "max_receive_count" {
    description = "maximum number of times that a message can be received by consumer"
    default = 5
}

variable "visibility_timeout" {
    description = "visibility timeout for the queue"
    default = 30
}