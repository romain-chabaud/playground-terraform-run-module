variable "app_name" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "env" {
  type = map(string)
}

variable "app_invoker_member" {
  type    = string
  default = "allUsers"
}