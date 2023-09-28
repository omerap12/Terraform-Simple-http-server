# create 
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

# Creare subnet for the vpc
resource "aws_subnet" "main-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "terraform-internet-gateway"
  }
}

# Create a custom route table
resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "terraform-route-table"
  }
}

# Create route
resource "aws_route" "main-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-gateway.id
  route_table_id         = aws_route_table.main-route-table.id
}

# Create association between the route table to the subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.main-route-table.id
}

# Create sg for the instance
resource "aws_security_group" "instance-sg" {
  vpc_id = aws_vpc.main.id
  name   = join("-", ["terraform", aws_vpc.main.id])
  ingress = [{
    description      = "http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0", aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    }, {
    description = "icmp traffic"
    cidr_blocks = ["0.0.0.0/0", aws_vpc.main.cidr_block]
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Outbound traffic rule"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  tags = {
    Name = "terraform-sg"
  }
}

# Create network interface
resource "aws_network_interface" "main-network-interface" {
  subnet_id       = aws_subnet.main-subnet.id
  security_groups = [aws_security_group.instance-sg.id]
}


# assign elastic ip to the network interface
resource "aws_eip" "main-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.main-network-interface.id
  associate_with_private_ip = aws_network_interface.main-network-interface.private_ip
  depends_on = [ aws_instance.instance ]
}