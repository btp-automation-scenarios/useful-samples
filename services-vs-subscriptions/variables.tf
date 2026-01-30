variable "globalaccount" {
  type        = string
  description = "Subdomain of the global account"
}

variable "entitlements" {
  type = map(list(string))
  default = {
    "alert-notification" = ["standard"]
    "auditlog"           = ["standard=1"]
    "cloud-logging"      = ["standard=1"]
    "sapappstudio"       = ["build-code"]
    "xsuaa"              = ["application"]
  }
}
