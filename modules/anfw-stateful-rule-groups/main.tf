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
      ip_sets {
        key = "PROD_VPCS"
        ip_set {
          definition = ["10.1.0.0/24","10.2.0.0/24"]
        }
      }
    }

    rules_source {
      dynamic "stateful_rule" {
        for_each = var.rules.stateful_rules
        content {
          action = stateful_rule.value.action

          header {
            destination      = stateful_rule.value.destination
            destination_port = stateful_rule.value.destination_port
            direction        = stateful_rule.value.direction
            protocol         = stateful_rule.value.protocol
            source           = stateful_rule.value.source
            source_port      = stateful_rule.value.source_port
          }

          rule_option {
            keyword  = stateful_rule.value.rule_option.keyword
            settings = stateful_rule.value.rule_option.settings
          }
        }
      }
    }
  }

  tags = var.rules.tags
}