# Infrastructure as code (IAC) EC2 instance

## Overview of project
This project consists of setting up an Amazon Web Services (AWS) Elastic Computing Cloud (EC2) instance with necessary security configurations and ubuntu server with a basic html page.

## Setup instructions 
For this project you will need the following:
- Install terraform locally on your machine if you don't already have it. Follow this link if you don't currently possess terraform https://learn.hashicorp.com/tutorials/terraform/install-cli
- Have an integrated development environment
(IDE) installed
- An AWS account
- AWS Secret access-key
- AWS access key

Things to do before running the project:
- Create a key pair pem key in an EC2 instance and ensure to name it iac-test. See link to setting up a key pair. https://www.how2shout.com/linux/add-a-new-key-pair-to-your-exisitng-aws-ec2-instances/
- After creation save your pem key to an .ssh folder on your local machine

## Running the project
1.  Clone the project and open the project up using your prefered IDE.
2.  On load of the project go to the file `terraform.tfvars`
3.  In the file replace the credentials placeholders with your actual credentials from AWS
4.  In the file replace the availability zone with the 3 availabilty zones closest to your present location
5.  After completion open your terminal and run the following command `terraform init` to initialise terraform on your local machine
6.  After initialising ensure the credentail changes you made earlier are running by using the command `terraform plan`
      - This command allows you understand the changes terraform will action before you apply the changes for real
      - If the command is successful you should see the amount of additions your changes will action


