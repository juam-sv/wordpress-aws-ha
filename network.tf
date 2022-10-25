resource "aws_vpc" "this" {
  cidr_block           = var.vpc_configuration.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

#------------------- SUBNETS CREATION ------------------------------------------------------
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

#------------------- NAT GATEWAY CREATION --------------------------------------------------
resource "aws_nat_gateway" "net_gateway_subnet_app" {
  for_each = toset(local.subnets_app)

  allocation_id = aws_eip.nat_gateway[each.value].id
  subnet_id     = aws_subnet.this[local.subnet_pairs[each.value]].id
}

resource "aws_eip" "nat_gateway" {
  for_each = toset(local.subnets_app)
  vpc      = true

  depends_on = [aws_internet_gateway.this]
}

#------------------- ROUTES CREATION --------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "internet_gateway" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = toset(local.public_subnets)
  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = toset(local.subnets_app)
  vpc_id   = aws_vpc.this.id
}

resource "aws_route" "nat_gateway" {
  for_each = toset(local.subnets_app)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[each.value].id
  nat_gateway_id         = aws_nat_gateway.net_gateway_subnet_app[each.value].id
}

resource "aws_route_table_association" "private" {
  for_each       = toset(local.subnets_app)
  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}
