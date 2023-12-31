<h2 align="center">
 <img src="screenshots/1280px-Terraform_Logo.svg.png" width="150"> Dev Environment - Azure +  Terraform <img src="screenshots/Microsoft_Azure_Logo.png" alt="OpenAI Logo" width="140"> 
</h2>

`Microsoft Azure`, `Hashicorp Terraform`, `Infrastructure as Code`, `Azure resource management`, `Cloud infrastructure management`

## 💡 Motivation

I suddenly got inspired to learn more about cloud infrastructure management and how to use automation tools to simplify and streamline the process of deploying and managing cloud resources after completing `Terraform + AWS course` on Udemy (btw, liked it!).

In the course, I was doing small tasks to understand how to create different resources separately and the overall power of Terraform for Infrastructure as Code, but I wanted to combine my knowledge and build something whole!

I chose to build a dev environment in Azure that I can SSH into to have my own redeployable environment & bootstrapped it with it with Docker for future projects.

I could practice managing cloud resources and learn more about Azure!

## Learned

I gained hands-on experience with Terraform and Azure (I played around first placing everything in one `main.tf` and later structuring it better for reusability; working with modules and connecting the resources), and developed a solid foundation for working with these technologies. This has inspired me to continue exploring the world of cloud infrastructure management and automation.

- Terraform (modules, data sources, custom_data, file, provisioner, templatefile, etc)
- Using external scripts
- Azure Resource management (SG Association, Linux VM, etc)
- Cloud Infrastructure Management

## Links & Demo

<h2 align="center">
 <img src="https://github.com/ayazhankadessova/dev-environment-tf-azure/assets/86869537/b81a062a-f3eb-4dca-9780-da49d1819273" width="700"> 
</h2>

- [Github Repo](https://github.com/ayazhankadessova/dev-environment-tf-azure)

## Run Locally

- Pre-req: Env Variables in `terraform.tfvars`, terraform, Azure Account.

1. Clone the project

```bash
  git clone https://github.com/ayazhankadessova/dev-environment-tf-azure.git
```

2. Go to the project directory

```bash
  cd dev-environment-tf-azure
```

3. Login to Azure

```bash
az login
```

4. Init

```bash
terraform init
```

5. Plan

```bash
terraform apply
```

6. Apply

```bash
terraform apply -auto-approve
```

## Author

- [@ayazhankadessova](https://github.com/ayazhankadessova)
- [Linkedin](https://www.linkedin.com/in/ayazhankad/)

## About Me

I'm an aspiring software developer from Kazakhstan, studying in Hong Kong.

👩‍💻 I'm currently improving my skills in React.js :)

- But as you see, in this project I learned Cloud Management & Automation :)

## ✍️ Project Steps & Notes

- Saved My Steps & Notes [here](https://github.com/ayazhankadessova/dev-environment-tf-azure/blob/main/Notes.md).
