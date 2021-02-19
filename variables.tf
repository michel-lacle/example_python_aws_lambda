variable "name" {
  type = string

  default = "sandbox1"
}

#
# the tags for this module
#
variable "application_tag" {
  type = string
  default = "sandbox"
}

variable "contact_tag" {
  type = string

  default = "foo@foo.com"
}

variable "managedby_tag" {
  type = string

  default = "foo@foo.com"
}