variable "sg_name" {
  type    = string
  default = "sg"
}

variable "sg_description" {
  type    = string
  default = "Allow all traffic from VPCs inbound and all outbound"
}

variable "sg_tags" {
  type    = map(string)
}

variable "vpc_id" {
  type    = string
}

variable "sg_rules" {
  type    = map(any)
}