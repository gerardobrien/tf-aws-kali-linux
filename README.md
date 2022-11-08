# Deploy Kali Linux on AWS using Terraform

Terraform code to 

1. Build VPC on AWS
2. Create a subnet within the VPC
3. Create an Internet Gateway and assign to VPC
4. Create a route table and assignit to the subnet
5. Build Kali Linux EC2 instance within the subnet
6. Build security group with rules to allow inbound SSH and RDP
7. Create EIP and assign to EC2 instance
