# Summary
This is a PoC that gives you an example of how to implement a highly available deployment of [ghost](https://ghost.org/docs/).

# Architectural Implementation
- We are following the [Multitenant SaaS on Azure](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/multi-saas/multitenant-saas) implementation, where we are splitting our resources across two regions and configuring Azure Front Door to prioritize traffic to a region we are calling active. Whenever this zone becomes unavailable the traffic is redirected to the standby region.
- The app service plan is configured to scale out in case we CPU metric increases, it won't be more than 4 instances and will scale in when it decreases.

# Technical debit
- Up to now Azure has not failover or replica set offers for the MySql database, it is possible to manually configure the database to replicate data to another database, but it was not implemented here.
- There is Azure Function to delete all posts from our blog, it could be created within the standby resource group as well, but it wasn't.
- Reading the documentation was not clear to me how Ghost works with storage accounts, so besides it is configured I am not sure it is working.
- Study how to work with modules in terraform to avoid duplicate scripts.

# How to run the application
I will consider you have a good understanding of Azure, Azure DevOps, and Terraform in order to proceed with this setup, so that will give you the main steps only.

## Terraform
You must have terraform installed and configured in your machine
So you can move the IaC\terraform and execute:

´´´terraform
terraform init
terraform plan -out=poc.tfplan
terraform apply "poc.tfplan"
´´´

To erase everything you can execute:
´´´terraform
terraform apply -destroy
´´´

it is also important you create a terraform.tfvars document within this directory and add credentials you will you to set up MySQL instance

´´´terraform
mysql_administrator_login = "admin"
mysql_administrator_login_password = "P@$$w0rd!"
´´´

you can learn more about how to set up your your environment for Azure [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_certificate)

## Azure DevOps
As long as you push this code to a Public Project within Azure DevOps you can run the pipelines for free.
We have created the pipelines as simple as possible just to run the PoC.

### Service connection
- AcrActive: Terraform deploys an Azure Container Registry within the active resource group, and you need to configure it here
- AcrStandby: Terraform deploys an Azure Container Registry within the standby resource group, and you need to configure it here
- AzSP001: This is an Azure Resource Manager service connection you will use to configure your service principal to run the pipelines

### Pipelines
- container-deploy-active-rg.yml ---> Within the active resource group, build our custom docker image, push the image to a private Azure Container Registry and Deploy to our Dev App Service Slot.
- container-deploy-standby-rg.yml ---> Within the standby resource group, build our custom docker image, push the image to a private Azure Container Registry and Deploy to our Dev App Service Slot.
- function-deploy-active-rg.yml ---> Within the active resource group, build our custom node function to delete all posts using the Ghost Admin API package and Deploy to our Production Azure Function.
- swap-dev-prod.yml --> Swaps Production and Dev Slots

### Expected flow
Once you have all the Service Connections configure you can execute the first three pipelines to deploy the container to your dev staging area, after that, you can configure what you want and use the swap pipeline to promote your configuration to production. It is important to remember Terraform doesn't let you specify what configurations belong to the slot, so unless you configure it within Azure Portal it will be overwritten.

### Configure Azure Function
Once you have deployed the Azure Function you need to provide a GHOST_ADMIN_KEY within the configuration area in Azure Portal. That is because we are using Ghost Admin Package to delete all posts. You can find instructions about how to create the ADMIN KEY [here](https://ghost.org/docs/admin-api/#token-authentication).
