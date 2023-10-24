resource "aws_security_group" "this" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  tags = var.sg_tags
}

resource "aws_security_group_rule" "this" {
  for_each = var.sg_rules

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.this.id
}

# resource "aws_instance" "spoke_vpc_a_host" {
#   ami                         = data.aws_ami.amazon-linux-2.id
#   subnet_id                   = aws_subnet.spoke_vpc_a_protected_subnet[0].id
#   iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
#   instance_type               = "t3.micro"
#   user_data_replace_on_change = true
#   vpc_security_group_ids      = [aws_security_group.spoke_vpc_a_host_sg.id]
#   tags = {
#     Name = "spoke-vpc-a/host"
#   }
#   user_data = file("install-nginx.sh")
# }

# output "spoke_vpc_a_host_ip" {
#   value = aws_instance.spoke_vpc_a_host.private_ip
# }