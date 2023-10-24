resource "aws_vpc" "inspection" {
  cidr_block = local.vpcs.inspection.cidr_block
  tags       = local.vpcs.inspection.tags
}

resource "aws_subnet" "inspection" {
  count = length(var.azs)

  vpc_id               = aws_vpc.inspection.id
  cidr_block           = cidrsubnet(local.vpcs.inspection.cidr_block, length(var.azs), count.index + 1)
  availability_zone_id = var.azs[count.index]

  tags = {
    Name = "${local.vpcs.inspection.name}-${var.azs[count.index]}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "inspection" {
  count = var.attach_tgw ? 1 : 0

  subnet_ids                                      = aws_subnet.inspection[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.this[0].id
  vpc_id                                          = aws_vpc.inspection.id
  transit_gateway_default_route_table_association = false
  appliance_mode_support                          = "enable"
  tags = {
    Name = "inspection-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_route" "pre_inspection_default_route" {
  count = var.attach_tgw ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection[0].id
  destination_cidr_block         = "0.0.0.0/0"
}

resource "aws_ec2_transit_gateway_route_table_association" "inspection_vpc_post_inspection_rtb" {
  count = var.attach_tgw ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection[0].id
}