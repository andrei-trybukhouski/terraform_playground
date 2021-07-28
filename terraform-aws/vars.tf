variable "project_name" {
  default = "TF-Test"
}

variable "common_tags" {
  type = map(any)
  default = {
    Owner   = "Andrei Trybukhouski"
    Project = "TF-Test"

  }
}
variable "serverscount" {
  default = 1
}
