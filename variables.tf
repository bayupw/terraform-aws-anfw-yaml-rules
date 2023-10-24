variable "aws_profile" {
  type    = string
  default = null
}

variable "prefix" {
  type    = string
  default = "bayu"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "create_tgw" {
  type    = bool
  default = false
}

variable "attach_tgw" {
  type    = bool
  default = false
}

variable "azs" {
  type = list(string)
  default = [
    "usw2-az1",
    #"usw2-az2",
  ]
}