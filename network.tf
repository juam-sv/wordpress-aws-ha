resource "aws_vpc" "this" {
  cidr_block           = var.vpc_configuration.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "this" {
  for_each = { for subnet in var.vpc_configuration.subnets : subnet.name => subnet }

  availability_zone_id    = local.az_pairs[each.key]
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.public

  tags = local.common_tags
}

resource "aws_subnet" "this_data" {
  for_each = { for subnet in var.vpc_configuration.subnets_data : subnet.name => subnet }

  availability_zone_id    = local.az_pairs[each.key]
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.public

  tags = local.common_tags
}