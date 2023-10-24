# ---------------------------------------------------------------------------------------------------------------------
# Firewall (Stateful) Rule Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "this" {
  capacity = var.rules.capacity
  name     = var.rules.name
  type     = var.rules.type

  rule_group {
    stateful_rule_options {
      rule_order = var.rules.rule_order
    }
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = var.rules.home_nets
        }
      }
      ip_sets {
        key = "PROD_VPCS"
        ip_set {
          definition = var.rules.prod_vpcs
        }
      }
    }

    rules_source {
      rules_string = file(var.rules.rules_file)
    }
  }

  tags = var.rules.tags
}