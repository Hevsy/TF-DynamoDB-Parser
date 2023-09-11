
variable "app" {
  type    = string
  default = "DynamoDB_parser"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "instance_stopped" {
  description = "If set to True the instace state is set to 'stopped' , else - to 'running' Stopped"
  type        = bool
  default     = "false"
}