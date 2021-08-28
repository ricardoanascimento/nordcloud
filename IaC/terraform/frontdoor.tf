resource "azurerm_frontdoor" "prod" {
  name                                         = "ghost-FrontDoor"
  resource_group_name                          = azurerm_resource_group.active_rg.name
  enforce_backend_pools_certificate_name_check = false
   
  routing_rule {
    name               = "ghostBlogRoutingRule"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["ghostFrontendEndpoint"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "ghostBackendBing"
    }
  }

  backend_pool_load_balancing {
    name = "ghostLoadBalancingSettings"
  }

  backend_pool_health_probe {
    name            = "ghostHealthProbeSetting"
    probe_method    = "HEAD"
    interval_in_seconds = "30"
  }

  backend_pool {
    name = "ghostBackendBing"

    backend {
      priority    = 1
      host_header = "${var.env_prefix}.azurewebsites.net"
      address     = "${var.env_prefix}.azurewebsites.net"
      http_port   = 80
      https_port  = 443
    }

    backend {
      priority    = 5
      host_header = "${var.env_prefix}-standby.azurewebsites.net"
      address     = "${var.env_prefix}-standby.azurewebsites.net"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "ghostLoadBalancingSettings"
    health_probe_name   = "ghostHealthProbeSetting"
  }

  frontend_endpoint {
    name                     = "ghostFrontendEndpoint"
    host_name                = "ghost-FrontDoor.azurefd.net"
    session_affinity_enabled = true 
  }
}