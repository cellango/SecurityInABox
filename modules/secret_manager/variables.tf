variable "name" {
   default =   ""
}
variable "app" {
   default =   ""
}
variable "team" {
   default =   ""
}
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "secret_name" {
   default =   ""
}
