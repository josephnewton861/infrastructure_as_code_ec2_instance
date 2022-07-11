# Infrastructure as code (IAC) EC2 instance

## Overview of project
This project consists of setting up an Amazon Web Services (AWS) on demand free Elastic Computing Cloud (EC2) instance with necessary security configurations and ubuntu server with a basic html page.

## Setup instructions 
For this project you will need the following:
- Install terraform locally on your machine if you don't already have it. Follow this link if you don't currently possess terraform https://learn.hashicorp.com/tutorials/terraform/install-cli
- Have an integrated development environment
(IDE) installed
- An AWS account
- AWS secret access-key
- AWS access key

Things to do before running the project:
- Create a key pair pem key in an EC2 instance and ensure to name it iac-test. See link to setting up a key pair. https://www.how2shout.com/linux/add-a-new-key-pair-to-your-exisitng-aws-ec2-instances/
- After creation save your pem key to an .ssh folder on your local machine

## Running the project
1.  Clone the project (please do not fork it) and open the project up using your prefered IDE.
2.  On load of the project go to the file `terraform.tfvars`
3.  Create a file of `terraform.tfvars` and In the file replace the credentials placeholders seen in the screenshot below with your actual credentials from AWS
![image](https://user-images.githubusercontent.com/57103519/178279483-441f0fe4-8af1-43f7-a982-f534e5c18cfd.png)
4.  In the file replace the availability zone with the 3 availabilty zones closest to your present location
5.  After completion open your terminal and run the following command `terraform init` to initialise terraform on your local machine
6.  After initialising ensure the credentail changes you made earlier are running by using the command `terraform plan`
      - This command allows you understand the changes terraform will action before you apply the changes for real
      - If the command is successful you should see the amount of additions your changes will action
7.  Go to your AWS account
8. Search for EC2 and on the left hand side click instances
9. Go back to your terminal and run the command `terraform apply`
      - This command actions the planned changes
      - Once the command has run you should see the following:
        - An EC2 instance running
        - Click the link of the instance and you should see a `Public IPv4 address` with a link that says open address
        - Once the link opens clcik the IP address and remove the `https://`
        - Add onto the end of the link add `/index.html` and enter. You should see a blank webpage and text that reads `My EC2 web server`
        - Go back to AWS and on the right hand panel you should see a link that says security groups and if clicked on it should show you a security group of                  test
        - Go back and seach for vpc. Click on it and you should a new VPC has been created of `test-vpc`
        - On the left hand side you should see a link that says subnets. Click on it an you will see the command has created 3 private and 3 public subnets
        - Go back on the left hand side the command should have also created a route table and internet gateway
10. After you have observed the instance and the feature the code has created. You need to now terminate the instance to stop unnecessary charges
11. Go back to your terminal and run the following `terraform destroy`
      - This command will terminate your instance along with all the security configurations made
      - If you want to re-run the code just run `terraform apply` and it should begin a new EC2 instance

## Notes
- This is only a free demonstration of configuring an EC2 instance from code and displaying a basic html page from an ubuntu server. If you want to further explore terraform and its capabilities please visit the following link https://www.terraform.io/
- The naming of the VPC, subnets, internet gateway etc are entirely up to you and can be changed according to your preferences
- For further AWS documentation on EC2 instances and additional features you can add to an instance e.g. a load balancer please visit the following https://docs.aws.amazon.com/ec2/index.html


