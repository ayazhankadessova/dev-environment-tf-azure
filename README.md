1. Install Azure CLI

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos

```
brew update && brew install azure-cli
```

2. Get Terraform & Terraform for Azure Extensions

3. Login & check

```
az Login

az account show
```

4. `Terraform init` only cares for `provider` stuff

5. Choose location

https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#geographies

6. Check your deployed resourceGroups

https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups

A subnet is a logical subdivision of an IP network. It is a range of IP addresses that can be used to create a separate network segment within a larger network.

In a subnet, all devices share a common prefix or network address and a unique host address. The network address determines the subnet, while the host address identifies a specific device within the subnet.

Subnets are commonly used to divide a large network into smaller segments, which can improve network performance, security, and management. By dividing a network into subnets, you can reduce network congestion and improve routing efficiency, since devices within a subnet can communicate directly with each other without having to traverse the entire network.

In cloud computing environments, such as Microsoft Azure or Amazon Web Services (AWS), subnets are used to create isolated network segments within a virtual network. By creating subnets, you can control access to resources and improve security by placing resources with similar security requirements in the same subnet.

For example, you might create separate subnets for web servers, application servers, and database servers, with each subnet having its own set of security rules and access controls. This can help to reduce the risk of unauthorized access or data breaches, while also improving network performance and management.

7. Check VN in RG

8. Check all the resources

```
terraform state list
```

9. Check info for one resource

```
terraform state show azurerm_resource_group.aya-rg
```

10. terraform show -> shows the whole state

11. terraform plan -destroy -> show what it will destroy

12. `terraform.tfsate.backup` -> we can use it if we mess up smth by just changing the name to `terraform.tfstate`

---

1. Deploy subnet to our VN using the variables from VN and rg

2. Check

3. Create `azurerm_network_security_group` as a separate resource

4. get your public ip address

```
169.150.218.4
```

---

## Associate our brand new security group with the subnet, so it actually be used to protect it.

When you associate a security group with a subnet, the security group rules will be applied to all instances that are launched in that subnet. The security group acts as a virtual firewall that controls the traffic that is allowed to and from the instances in the subnet.

For example, if you create a security group that allows inbound traffic on port 80 (HTTP) and port 443 (HTTPS), and then associate that security group with a subnet, any instances launched in that subnet will only allow incoming traffic on those ports from sources that are explicitly allowed by the security group rules. Any traffic that does not meet the rules will be blocked.

Associating a security group with a subnet is a way of controlling network access to the instances in the subnet. By default, all traffic is blocked, and you must explicitly allow traffic through the security group rules. This helps to improve the overall security of your network by reducing the attack surface and preventing unauthorized access to your instances.

In summary, associating a security group with a subnet allows you to control the traffic that is allowed to and from the instances in the subnet, and provides an additional layer of security for your network.

Network sg protects subnet.

## Give our Virtual Machine a way to the internet by creating a public IP
