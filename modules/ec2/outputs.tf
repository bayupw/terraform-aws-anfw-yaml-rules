output "aws_security_group" {
  description = "AWS Security Group as an object with all of its attributes."
  value       = aws_security_group.this
}

output "aws_security_group_rule" {
  description = "AWS Security Group Rules as an object with all of its attributes."
  value       = aws_security_group_rule.this[*]
}