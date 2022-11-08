# Create VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.50.50.0/24"
  instance_tenancy = "default"

  tags = {
    Name  = "Kali VPC"
    Owner = "Gerard O'Brien"
  }
}



# Create subnet for Kali VM
resource "aws_subnet" "kali-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.50.50.0/27"

  tags = {
    Name  = "Kali Subnet"
    VPC  = "Kali VPC"
    Owner = "Gerard O'Brien"
  }
}



# Create an Internet Gateway
resource "aws_internet_gateway" "kali-inet-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "Kali VPC Inet GW"
    VPC  =  "Kali VPC"
    Owner = "Gerard O'Brien"
  }
}



# Create a Route Table and assign default route
resource "aws_route_table" "kali-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kali-inet-gw.id
  }

  tags = {
    Name  = "Kali Subnet Route Table"
    VPC  =  "Kali VPC"
    Owner = "Gerard O'Brien"
  }
}


# Assign Route Table to Kali subnet
resource "aws_route_table_association" "kali-subnet-rt" {
  subnet_id = aws_subnet.kali-subnet.id
  route_table_id = aws_route_table.kali-route-table.id
}



# Create Elastic IP for the Kali EC2 instance
#resource "aws_eip" "kali-pip" {

#tags = {
    #Name  = "Kali PIP"
    #VPC  =  "Kali VPC"
    #Owner = "Gerard O'Brien"
  #}
#}



# Build Kali EC2 VM
 resource "aws_instance" "kali-ec2" {
  ami           = "ami-0136c1141393311b7"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
    Owner = var.owner_name
  }

  user_data = "${file("xrdp.sh")}"
  key_name = "kali"
  subnet_id = "${aws_subnet.kali-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_sshrdp.id}"]
  associate_public_ip_address = "true"

}








# Find my current Public IP
data "http" "my_public_ip" {
    url = "https://ipv4.icanhazip.com"
}




# Allow SSH to Kali Linux
resource "aws_security_group" "allow_sshrdp" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.main.id}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = ["${chomp(data.http.my_public_ip.body)}/32"]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks     = ["${chomp(data.http.my_public_ip.body)}/32"]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3390
    to_port     = 3390
    protocol    = "tcp"
    cidr_blocks     = ["${chomp(data.http.my_public_ip.body)}/32"]
    #cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "Kali Security Group"
    VPC  =  "Kali VPC"
    Owner = "Gerard O'Brien"
  }

}

