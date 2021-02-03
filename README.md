There is a Terraform template for deploying several FTD appliance with High Availability
Aproach details here
https://community.cisco.com/t5/security-documents/high-availability-and-scalability-design-and-deployment-of-cisco/ta-p/4109439

https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/azure/ftdv-azure-gsg/ftdv-azure-intro.html

## FTD appliance needs additional configuration
* set outside DNAT
* set default route to outside interface
* set route for user subnets to inside interface
* set route for azure-lb-utility-ip (168.63.129.16) to inside interface ( for iLB probe check )
* accept ssh connection from azure-lb-utility-ip (168.63.129.16) on inside interface ( for iLB probe check )

## To accept Cisco FTDv legal terms use following Azure CLI commands
## set subscription ID if your accout has several subscriptions
### az account set --subscription <subscription_id> 
## then accept license agreement
### az vm image terms accept --urn <publisher>:<offer>:<sku>:<version>
* Example:
* az account set --subscription 11223344-5566-7788-99aa-bbccddeeff00
* az vm image terms accept --urn cisco:cisco-ftdv:ftdv-azure-byol:66190.0.0 
