variable "env_prefix" {
  default     = "ghostpoc"
  description = "Environment prefix, no alpha numeric characters"
}

variable "mysql_administrator_login" {
  description = "Username to authenticate with mysql"
}

variable "mysql_administrator_login_password" {
  description = "Password of the host to access the database"
}

variable "allowed_service_tag_active" {
  default = "AppService.WestEurope"
  description = "Service tag that representes AppService.Region where the active region is located"
}

variable "allowed_service_tag_standby" {
  default = "AppService.UKSouth"
  description = "Service tag that representes AppService.Region where the standby region is located"
}