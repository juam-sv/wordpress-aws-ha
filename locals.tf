locals {
  subnets_app           = sort([for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == false])
  subnets_data          = sort([for subnet in var.vpc_configuration.subnets_data : subnet.name if subnet.public == false])
  public_subnets        = sort([for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == true])
  azs                   = sort(slice(data.aws_availability_zones.available.zone_ids, 0, length(local.subnets_app)))
  subnet_pairs          = zipmap(local.subnets_app, local.public_subnets)
  subnet_pairs_app_data = zipmap(local.subnets_app, local.subnets_data)

  az_pairs = merge(
    zipmap(local.public_subnets, local.azs),
    zipmap(local.subnets_app, local.azs),
    zipmap(local.subnets_data, local.azs)
  )

  s3_bucket_name = "wordpress-${random_integer.rand.result}"
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company    = var.company
    project    = "${var.company}-${var.project}"
    enviroment = "${var.project}-${var.enviroment}"
  }
}