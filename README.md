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

## Give our Virtual Machine a way to the internet by creating a public IP, Retrieve the Dynamic Public IP of a new VM)

```
resource "azurerm_public_ip" "example" {
  name                    = "test-pip"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}
```

simple, keep name as `test-pip`

When pip, public ip will not be known even after apply, it will be only known after being attached to something & then used.

Once we deploy our other resources, we will have the ip.

## Create network interface that we will attack to our VM to provide network connectivity. This NIC will receive its public IP address from the IP address we just created.

Dynamic means "An IP is automatically assigned during creation of this Network Interface"; Static means "User supplied IP address will be used"

## Specify the admin ssh, generate rsa key pair

```
ssh-keygen -t rsa
```

``
admin_ssh_key {
username = "adminuser"
public_key = file("~/.ssh/id_rsa.pub")
}

```


```

ls ~/.ssh

```

## paste ip address

After creating VM, we can get the ip address:

```

public_ip_address = ...

```

public_ip_address               = "172.190.169.84"

## Go into virtualMachine

> ssh -i ~/.ssh/id_rsa adminuser@*ipaddr*
> ssh -i ~/.ssh/id_rsa adminuser@172.190.215.154

```

adminuser@aya-machine:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 20.04.6 LTS
Release: 20.04
Codename: focal

```
- We have Ubuntu Instance.

## Custom Data

We are going to utilize the Custom Data argument to bootstrap our instance & install the Docker engine. This will allow us to have a Linux VM instance deployed with Docker ready to go for all of our development needs.

- bash file helps to install all the dependencies neccessary for installing Docker on our Machine: get the commands from https://docs.docker.com/engine/install/ubuntu/

add custom data to VM instance

- filebase64 encodes data in base64, which is what Azure is expecting for Custom Data.

```

custom_data = filebase64("customdata.tpl")

```

- custom_data requires the VM to be redeployed, so it will Add 1, destroy 1.

## Check if we can login to VM now, public ip changed

> ssh -i ~/.ssh/id_rsa adminuser@20.124.118.139

*search for ssh comman* cmd +r and type "ss"

```

adminuser@aya-machine:~$ docker --version
Docker version 24.0.2, build cb74dfc

```

-> now we have Docker installed in our brand new VM ready to go.

## SSH Config Scripts

We are going to install the `remote-SSH` extension in VS Code to open a remote terminal in our VM. Then, we are going to look at configuration scripts we are going to use to insert the VM host information, such as the IP address, into our SSH config file that VS code uses to connect to those instances.

- We will be able to connect to our host using VS Code. We are going to use a provisioner to configure the VS Code on our local terminal to be able to `ssh` into our remote VM.

## Provisioners

https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax

Now, a provisioner is not something you want to use for every deployment. Unlike other resources, a provisioner's success or failure will not be recorded or managed by state. So if something goes wrong, that's just too bad. There is no no rollback or any other way to manage it other than just running it again. While this is not great for configuring remote instances, it is perfectly find for something like this. Just adding information to a config file on our local terminal. This is a lightweight operation that doesn't affect the overall success of the deployment if something were to go wrong.

Overall, if you need something simple to do, use a provisioner. If you are configuring a remote instance, it's usually best to either use user data, custom data, or another type of application such as Ansible.

To display the command palette, use the following keyboard shortcut, based on your installed operating system: macOS: Command+Shift+P. Windows: Ctrl+Shift+P.

- config should look smth like:

```

Host
HostName
User
IdentityFile

```

Get all the info from our instance & insert it into the config file

Create tpl depending on your OS

It will add our config to the config file we have Specify.
We will pass variables using the template function.

## Setup provisioner

We will set it up inside the `azurerm_linux_virtual_machine`

```

command = templatefile("linux-ssh-script.tpl", {
hostname = self.public_ip_address,
user = "adminuser",
identityfile = "~/.ssh/id_rsa" // private_key
})

```

Provisioner does not get picked up by the state. Terraform doesnt now we change anything. So, we need to  get rid of VM & reapply.

> terraform apply -replace azurerm_linux_virtual_machine.aya-vm

Replaces VM & runs provisioner

Command Plate -> remote-ssh -> find public IP, checkout if docker is installed
```
