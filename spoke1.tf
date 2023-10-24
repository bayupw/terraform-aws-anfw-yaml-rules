resource "aws_vpc" "spoke1" {
  cidr_block = local.vpcs.spoke1.cidr_block
  tags       = local.vpcs.spoke1.tags
}

resource "aws_subnet" "spoke1" {
  count = length(var.azs)

  vpc_id               = aws_vpc.spoke1.id
  cidr_block           = cidrsubnet(local.vpcs.spoke1.cidr_block, length(var.azs), count.index + 1)
  availability_zone_id = var.azs[count.index]

  tags = {
    Name = "${local.vpcs.spoke1.name}-${var.azs[count.index]}"
  }
}

module "spoke1_ec2" {
  source = "./modules/ec2"

  sg_tags  = local.vpcs.spoke1.tags
  vpc_id   = aws_vpc.spoke1.id
  sg_rules = local.sg_rules.spoke1
}

# Spoke1 TGW Attachment

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke1" {
  count = var.attach_tgw ? 1 : 0

  subnet_ids                                      = aws_subnet.spoke1[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.this[0].id
  vpc_id                                          = aws_vpc.spoke1.id
  transit_gateway_default_route_table_association = false
  tags = {
    Name = "spoke1-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke1_vpc_pre_inspection_rtb" {
  count = var.attach_tgw ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke1_vpc_post_inspection_rtb" {
  count = var.attach_tgw ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke1[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection[0].id
}