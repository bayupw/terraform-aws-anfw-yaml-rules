locals {
  vpcs                     = yamldecode(file("${path.module}/input/vpcs.yaml"))
  sg_rules                 = yamldecode(file("${path.module}/input/sg-rules.yaml"))
  fivetuple_rule_group_001 = yamldecode(file("${path.module}/input/fivetuple-rule-group-001.yaml"))
  fqdn_rule_group_001      = yamldecode(file("${path.module}/input/fqdn-rule-group-001.yaml"))
}

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "${var.prefix}-transit-gateway"
  }
}

resource "aws_ec2_transit_gateway_route_table" "pre_inspection" {
  count = var.create_tgw ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  tags = {
    Name = "pre-inspection-rtb"
  }
}

resource "aws_ec2_transit_gateway_route_table" "post_inspection" {
  count = var.create_tgw ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  tags = {
    Name = "post-inspection-rtb"
  }
}