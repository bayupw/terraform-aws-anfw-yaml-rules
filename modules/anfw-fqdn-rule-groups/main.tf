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
          definition = var.home_nets
        }
      }
    }

    rules_source {
      rules_source_list {
        generated_rules_type = var.rules.generated_rules_type
        target_types         = var.rules.target_types
        targets              = var.rules.targets
      }
    }
  }

  tags = var.rules.tags
}