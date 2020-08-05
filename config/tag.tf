locals {
  tags = {
    ITOwnerEmail          = "Clement Ellango"
    BillingCode           = "XXXXXXXX"
    env                   = var.env
  }
}


locals {
  standard_tags = {
    ITOwnerEmail          = "Clement_Ellango@cargill.com"
    BillingCode           = "XXXXXXXX"
    env                  = var.env
    Name                 = var.app
  }
}