locals {
  fivetuple_rule_group_001 = yamldecode(file("${path.module}/input/fivetuple-rule-group-001.yaml"))
  fqdn_rule_group_001      = yamldecode(file("${path.module}/input/fqdn-rule-group-001.yaml"))
}

# ---------------------------------------------------------------------------------------------------------------------
# Firewall (Stateful) Rule Groups
# ---------------------------------------------------------------------------------------------------------------------
module "fivetuple_rule_group_001" {
  source = "./modules/anfw-stateful-rule-groups"

  rules = local.fivetuple_rule_group_001
  home_nets = [
    "10.1.0.0/24",
    "10.2.0.0/24",
  ]
}

module "suricata_rule_group_001" {
  source = "./modules/anfw-suricata-rule-groups"

  rules = {
    capacity    = 10
    name        = "suricata-rules"
    type        = "STATEFUL"
    rule_order  = "STRICT_ORDER"
    description = "Stateful rules suricata"
    home_nets   = ["10.1.0.0/24", "10.2.0.0/24"]
    prod_vpcs   = ["10.100.0.0/24", "10.200.0.0/24"]
    rules_file  = "./input/suricata.rules"
    tags = {
      tag1 = "value1"
      tag2 = "value2"
    }
  }
}

module "fqdn_rule_group_001" {
  source = "./modules/anfw-fqdn-rule-groups"

  rules = local.fqdn_rule_group_001
  home_nets = [
    "10.1.0.0/24",
    "10.2.0.0/24",
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Firewall Policy
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "anfw_policy" {
  name = "bayu-anfw-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }

    stateful_rule_group_reference {
      priority     = 1
      resource_arn = module.fivetuple_rule_group_001.aws_networkfirewall_rule_group.arn
    }

    stateful_rule_group_reference {
      priority     = 20
      resource_arn = module.suricata_rule_group_001.aws_networkfirewall_rule_group.arn
    }

    stateful_rule_group_reference {
      priority     = 30
      resource_arn = module.fqdn_rule_group_001.aws_networkfirewall_rule_group.arn
    }

  }
}