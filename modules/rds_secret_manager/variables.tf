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
# variable "secret_string" {
#    default =   ""
# }

variable "username" {
  description = "The MySQL/Aurora username you chose during RDS creation or another one that you want to rotate"
}
variable "dbname" {
  description = "The Database name inside your RDS"
}
variable "host" {
  description = "The RDS endpoint to connect to your database"
}
variable "password" {
  description = "The password that you want to rotate, this will be changed after the creation"
}
variable "port" {
  default = 5432
  description = "In case you don't have your MySQL on default port and you need to change it"
}
variable "dbClusterIdentifier" {
  description = "The RDS Identifier in the webconsole"
}
variable "engine" {
  description = "The RDS engine in the webconsole"

}
# variable "dbInstanceIdentifier" {
#    default =   ""
# }
variable "secret_name" {
   default =   ""
}
