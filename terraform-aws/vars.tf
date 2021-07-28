variable "common_tags" {
  type        = map
  default = {
    Owner       = "Andrei Trybukhouski"
    Project     = "TF-Test"

  }
}
variable "serverscount" {
  default = 1
}