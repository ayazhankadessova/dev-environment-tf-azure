<h2 align="center">
 <img src="https://media.giphy.com/media/fGL6oc26zsv6sA1sLx/giphy.gif" width="90">Dev Environment - Azure +  Terraform <img src="images/OpenAIlogo.png" alt="OpenAI Logo" width="40">  <img src="https://media.giphy.com/media/fGL6oc26zsv6sA1sLx/giphy.gif" width="90">
</h2>

`Microsoft Azure`, `Hashicorp Terraform`, `Infrastructure as Code`, `Azure resource management`, `Cloud infrastructure management`

## Check my App out [here](https://trip-generator-openai.netlify.app) !

![dev-env](https://github.com/ayazhankadessova/tf-azure/assets/86869537/feeef861-b02a-42e0-8a8b-c4ec2ce7adc0)

## 💡 Motivation

I suddenly got inspired to learn more about cloud infrastructure management and how to use automation tools to simplify and streamline the process of deploying and managing cloud resources after completing `Terraform + AWS course` on Udemy (btw, liked it!).

In the course, I was doing small tasks to understand how to create different resources separately and the overall power of Terraform for Infrastructure as Code, but I wanted to combine my knowledge and build something whole!

I chose to build a dev environment in Azure, so I could practice managing cloud resources and learn more about Azure, which I had no exposure to earlier!

## Learned

I gained hands-on experience with Terraform and Azure (I played around first placing everything in one `main.tf` and later structuring it better for reusability; working with modules and connecting the resources), and developed a solid foundation for working with these technologies. This has inspired me to continue exploring the world of cloud infrastructure management and automation.

- Terraform (modules, data sources, custom_data, file, provisioner, templatefile, etc)
- Using external scripts
- Azure Resource management (SG Association, Linux VM, etc)
- Cloud Infrastructure Management

## Links & Demo

<p align="center">
<img src="https://github.com/ayazhankadessova/trip-generator-OpenAI/assets/86869537/8a93377f-859c-42be-b39e-3b13304e062f" width="800" alt="trip-generator-inf">
</p>

- [Github Repo](https://github.com/ayazhankadessova/trip-generator-with-OpenAI)

## Run Locally

1. Clone the project

```bash
  git clone https://github.com/ayazhankadessova/trip-generator-with-OpenAI.git
```

2. Go to the project directory

```bash
  cd trip-generator-with-OpenAI
```

3. Install dependencies

```bash
npm install
```

4. Get & insert Api key

I [cleaned my api key](https://til.simonwillison.net/git/rewrite-repo-remove-secrets), so you will have to **use your own.**

5. Start the app

```bash
npm run dev
```

## Author

- [@ayazhankadessova](https://github.com/ayazhankadessova)
- [Linkedin](https://www.linkedin.com/in/ayazhankad/)

## About Me

I'm aspiring software developer from Kazakhstan, studying in Hong Kong.

👩‍💻 I'm currently improving my skills in React.js :)

## What I learned:

1. Used the OpenAI API

- text-davinci-003 model
- creatCompletions endpoint

2. Zero shot approach -> Few shot

- max_tokens
- temperature

3. Goals:

- Make better frontend

4. Tools:

- Gif creator: https://www.cockos.com/licecap/

One of the coolest things about this project was that it allowed me to create my own redeployable environment. With the help of Visual Studio Code, I deployed Azure resources and an Azure VM, which I could SSH into whenever I needed to use my environment. This was perfect for my future projects, as I could easily recreate my environment whenever I needed to.

## Useful commands

1. Check all the resources

```
terraform state list
```

2. Check info for one resource

```
terraform state show azurerm_resource_group.aya-rg
```

3. Show the whole state

`terraform show``

4. Show what will be destroyed

`terraform plan -destroy`

5. `terraform.tfsate.backup` -> we can use it if we mess up smth by just changing the name to `terraform.tfstate`

### 1. Local Environment Setup

1. Install Azure CLI

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos

```
brew update && brew install azure-cli
```

2. Get `Terraform` & `Terraform for Azure` Extensions

3. Login & check

```
az Login

az account show
```

### 2. Azure Provider & Init

1. `Terraform init` only cares for `provider` stuff

2. Choose location

https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#geographies

### 3. Resource Group

- Check your deployed resourceGroups

https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups

### 4. Virtual network configuration

- Check `.terraform.tfstate` -> your resources are there

### 5. Subnet

A subnet is a logical subdivision of an IP network. It is a range of IP addresses that can be used to create a separate network segment within a larger network.

In a subnet, all devices share a common prefix or network address and a unique host address. The network address determines the subnet, while the host address identifies a specific device within the subnet.

Subnets are commonly used to divide a large network into smaller segments, which can improve network performance, security, and management. By dividing a network into subnets, you can reduce network congestion and improve routing efficiency, since devices within a subnet can communicate directly with each other without having to traverse the entire network.

- In cloud computing environments, such as Microsoft Azure or Amazon Web Services (AWS), subnets are used to create `isolated network segments` within a virtual network. By creating subnets, you can control access to resources and improve security by placing resources with similar security requirements in the same subnet.

For example, you might create separate subnets for web servers, application servers, and database servers, with each subnet having its own set of security rules and access controls. This can help to reduce the risk of unauthorized access or data breaches, while also improving network performance and management.

1. Deploy subnet to our VN using the variables from VN and rg
2. Check VN in Resource Group -> subnet is there!

### 6. A Security Group

1. Create `azurerm_network_security_group`

2. get your public ip address
   https://www.whatismyip.com

### 7. A Security Group Association

- Associate our brand new security group with the subnet, so it actually be used to protect it.

When you associate a security group with a subnet, the **security group rules will be applied to all instances that are launched in that subnet**. The security group acts as a virtual firewall that controls the traffic that is allowed to and from the instances in the subnet.

For example, if you create a security group that allows inbound traffic on port 80 (HTTP) and port 443 (HTTPS), and then associate that security group with a subnet, any instances launched in that subnet will only allow incoming traffic on those ports from sources that are explicitly allowed by the security group rules. Any traffic that does not meet the rules will be blocked.

Associating a security group with a subnet is a way of controlling network access to the instances in the subnet. By default, all traffic is blocked, and you must explicitly allow traffic through the security group rules. This helps to improve the overall security of your network by reducing the attack surface and preventing unauthorized access to your instances.

- **Associating a security group with a subnet allows you to control the traffic that is allowed to and from the instances in the subnet, and provides an additional layer of security for your network.**

- Network SG protects subnet.

### 8. A Public IP

- Give our Virtual Machine a way to the internet by creating a public IP, Retrieve the Dynamic Public IP of a new VM)

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

- **Public ip will not be known even after apply, it will be only known after being attached to something & then used.** -> Once we deploy our other resources, we will have the ip.

### 9. Network Interface

Create network interface that we will attach to our VM to provide network connectivity. This NIC will receive its public IP address from the IP address we just created.

- Dynamic means "An IP is automatically assigned during creation of this Network Interface";

- Static means "User supplied IP address will be used"

### 10. Specify the admin ssh, generate rsa key pair

1. Generate the RSA key pair (if you don't have) -> check `ls ~/.ssh`

```
ssh-keygen -t rsa
```

2. Add to configuration options

```
admin_ssh_key {
username = "adminuser"
public_key = file("~/.ssh/id_rsa.pub")
}

```

### 11. A Linux VM

1. Paste ip address -> Create

After creating VM, we can get the ip address:

```

public_ip_address = ...

```

### 12. Go into VM

> ssh -i ~/.ssh/id*rsa adminuser@\_ipaddr*

```

adminuser@aya-machine:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 20.04.6 LTS
Release: 20.04
Codename: focal

```

- We have Ubuntu Instance.

### 13. Custom Data -> Bootstrap with Docker

- scripts/customdata.tpl

We are going to utilize the Custom Data argument to bootstrap our instance & install the Docker engine. This will allow us to have a Linux VM instance deployed with Docker ready to go for all of our development needs.

1. bash file helps to install all the dependencies needed for installing Docker on our Machine: get the commands from https://docs.docker.com/engine/install/ubuntu/

2. add custom data to VM instance

3. filebase64 encodes data in base64, which is what Azure is expecting for Custom Data.

```

custom_data = filebase64("scripts/customdata.tpl")

```

4. `custom_data` requires the VM to be redeployed, so it will Add 1, destroy 1.

### 14. Check if we can login to VM now, public ip changed

> ssh -i ~/.ssh/id*rsa adminuser@\_newIP*

_search for ssh command_ cmd +r and type "ss"

### Check if we have the docker

```

adminuser@aya-machine:~$ docker --version
Docker version 24.0.2, build cb74dfc

```

-> now we have Docker installed in our brand new VM ready to go.

### 15. SSH Config Scripts

We are going to install the `remote-SSH` extension in VS Code to open a remote terminal in our VM. Then, we are going to look at configuration scripts we are going to use to insert the VM host information, such as the IP address, into our SSH config file that VS code uses to connect to those instances.

- We will be able to connect to our host using VS Code. We are going to use a provisioner to configure the VS Code on our local terminal to be able to `ssh` into our remote VM.

## Provisioners

https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax

A provisioner is not something you want to use for every deployment. Unlike other resources, a provisioner's success or failure will not be recorded or managed by state. So if something goes wrong, that's just too bad. There is no no rollback or any other way to manage it other than just running it again. While this is not great for configuring remote instances, it is perfectly find for something like this. Just adding information to a config file on our local terminal. This is a lightweight operation that doesn't affect the overall success of the deployment if something were to go wrong.

Overall, if you need something simple to do, use a provisioner. If you are configuring a remote instance, it's usually best to either use user data, custom data, or another type of application such as Ansible.

To display the command palette, use the following keyboard shortcut, based on your installed operating system: macOS: Command+Shift+P. Windows: Ctrl+Shift+P.

- config should look smth like:

```
Host
HostName
User
IdentityFile

```

1. Get all the info from our instance & insert it into the config file
2. Create tpl depending on your OS [scripts/osx-ssh-script.tpl] -> It will add our config to the config file we have specified.
3. We will pass variables using the template function.

### 16. Setup provisioner

We will set it up inside the `azurerm_linux_virtual_machine`

```

command = templatefile("linux-ssh-script.tpl", {
hostname = self.public_ip_address,
user = "adminuser",
identityfile = "~/.ssh/id_rsa" // private_key
})

```

- Provisioner does not get picked up by the state. Terraform doesn't know we changed anything. So, we need to:

1. Get rid of VM & reapply.

> terraform apply -replace azurerm_linux_virtual_machine.aya-vm

- Replaces VM & runs provisioner

### 16. SSH into VM

## 17. Connect to Host

> Command Pallette -> remote-ssh:connect to host -> choose the public ip address -> continue -> connected to remote!

> docker --version

should show installed docker version

**Done !**

## 18. Terraform Data sources (extra)

https://developer.hashicorp.com/terraform/language/data-sources

Data sources are ways that we can query items from the provider; in this case, Azure API, and use it within our code.

Although we don't really need it since it is already available in our state file, let's just query the public IP we're using just to see data sources work.

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip

```

data "aws_ami" "example" {
most_recent = true

owners = ["self"]
tags = {
Name = "app-server"
Tested = "true"
}
}

```

```

data "azurerm_public_ip" "aya-ip-data" {
name = azurerm_public_ip.aya-ip.name
resource_group_name = azurerm_resource_group.aya-rg.name
}

```

- No need to apply, just refresh

> terraform apply -refresh-only

- Check `.tfstate` -> Data source is added -> ip is There
