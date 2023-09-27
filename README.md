# AWS Infrastructure with Terraform

This Terraform configuration sets up an AWS infrastructure including a Virtual Private Cloud (VPC), a public subnet, an internet gateway, a custom route table, security groups, a network interface, and an EC2 instance.  
This code will deploy a simple http server running on ec2 instance.


## Prerequisites
Before you begin, make sure you have the following prerequisites:

Terraform installed on your local machine.
AWS credentials configured with appropriate permissions.
Configuration Files
## Terraform Files

* main.tf: Contains the main Terraform configuration for creating AWS resources.
* variables.tf: Defines input variables used in the configuration.
* userdata.sh: User data script executed on EC2 instance launch.

## Terraform Resources
* AWS VPC (aws_vpc.main)
CIDR Block: 10.0.0.0/16. 
Instance Tenancy: default.  
* AWS Subnet (aws_subnet.main-subnet)
VPC Association: Associated with aws_vpc.main.
CIDR Block: 10.0.1.0/24. 
Availability Zone: us-east-1a
* AWS Internet Gateway (aws_internet_gateway.main-gateway)
* VPC Association: Attached to aws_vpc.main.
* AWS Route Table (aws_route_table.main-route-table)
* VPC Association: Associated with aws_vpc.main.
* AWS Route (aws_route.main-route)
Default Route: Allows traffic to 0.0.0.0/0 via the Internet Gateway.
* AWS Route Table Association (aws_route_table_association.subnet-association)
Associates the subnet with the custom route table.
* AWS Security Group (aws_security_group.instance-sg)
* VPC Association: Associated with aws_vpc.main.
* Ingress Rules: Allows HTTP traffic (port 80) from anywhere and ICMP traffic (ping) from within the VPC.
* Egress Rules: Allows all outbound traffic.
* AWS Network Interface (aws_network_interface.main-network-interface)
* Subnet Association: Associated with aws_subnet.main-subnet.
* Security Groups: Assigned aws_security_group.instance-sg.
* AWS Elastic IP (aws_eip.main-eip)
* VPC Association: Associated with a network interface.
Associates with a private IP address of the network interface.
* AWS EC2 Instance (aws_instance.instance)
AMI: Default is "ami-053b0d53c279acc90".  
Instance Type: Default is "t2.micro".  
Availability Zone: us-east-1a.  
Network Interface: Attached to aws_network_interface.main-network-interface.  
User Data: Executes the userdata.sh script.  
Tags: Named "webserver".
## Usage
Clone this repository to your local machine.

Configure your AWS credentials using aws configure.

Run terraform init to initialize the working directory.

Run terraform apply to create the AWS infrastructure.

After the infrastructure is created, you can SSH into the EC2 instance using the Elastic IP address.

To destroy the infrastructure, run terraform destroy.

### Variables
* ami: The AMI for the EC2 instance. Default is "ami-053b0d53c279acc90".
* instances_number: Number of instances to launch. Default is 1.
* instance_type: EC2 instance type to launch. Default is "t2.micro".


