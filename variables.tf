variable "prefix" {
  default = "phonebook"
}

# MySQL Flexible Database
variable "db_server_name" {
  description = "Should be unique"
  default     = "nbtdb-wordpress"
}

variable "db_username" {
  description = "Should match with 'phonebook-app.py' line #20"
  default     = "nbt"
}

variable "db_password" {
  description = "Should match with 'phonebook-app.py' line #21"
  default     = "Password1234"
}

# Resource group
variable "location" {
  default = "eastus"
}