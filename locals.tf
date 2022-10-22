locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    environment  = "${var.project}-${var.environment}"
  }
}