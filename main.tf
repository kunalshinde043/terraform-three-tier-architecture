#================================================================
#======================PROVIDER CONFIGURATIONS====================
#================================================================


provider "aws" {
  region = var.region
}

#================================================================
#======================BACKEND CONFIGURATIONS====================
#================================================================


terraform {
  backend "s3" {
    bucket = "three-tier-project-terraform-backend-k55"
    key = "Terraform State Files"
    region = "us-east-1"
  }
}

#================================================================
#======================NETWORK CONFIGURATIONS====================
#================================================================


#================================================================
#VPC CONFIGS

resource "aws_vpc" "my_vpc" {
  cidr_block = var.my_vpc_cidr
  tags = {
    Name = "Kunal-Enterprises-VPC"
  }
}

#================================================================
#Private Subnet configs Application-Server

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.private_subnet_az
  tags = {
    Name = "Private-Subnet-1"
  }
}

#================================================================
#Private Subnet configs DB-Server

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.private_subnet_2_az
  tags = {
    Name = "Private-Subnet-2"
  }
}

#================================================================
#Public Subnet configs Bastion-Host

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.public_subnet_az
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet"
  }
}

#================================================================
#Internet Gateway configs

resource "aws_internet_gateway" "my-IGW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Kunal-IGW"
  }
}

resource "aws_eip" "my_eip" {
    tags = {
      Name = "my-NAT-GW"
    }
}

#================================================================
#NAT Gateway configs

resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.my_eip.allocation_id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "gw NAT"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my-IGW]
}


#================================================================
#Route table configs-(Default RT)

resource "aws_default_route_table" "main-RT" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  tags = {
    Name = "Main-RT-Table"
  }
}

#================================================================
#Route table configs-(Private RT)

resource "aws_route_table" "Private-RT" {
  vpc_id = aws_vpc.my_vpc.id

  route {
  cidr_block = var.ngw-cidr
  gateway_id = aws_nat_gateway.my_nat_gw.id
  }

  tags = {
    Name = "Private-RT-Table"
  }

}

resource "aws_route" "IGW-route" {
  route_table_id = aws_default_route_table.main-RT.id
  destination_cidr_block = var.igw-cidr
  gateway_id = aws_internet_gateway.my-IGW.id
}



#================================================================
#Subnet associations

resource "aws_route_table_association" "db-server-association-b" {
  route_table_id = aws_route_table.Private-RT.id
  subnet_id = aws_subnet.private_subnet_2.id
}

resource "aws_route_table_association" "db-server-association-c" {
  route_table_id = aws_default_route_table.main-RT.id
  subnet_id = aws_subnet.public_subnet.id
}


resource "aws_security_group" "my-sg" {
  vpc_id = aws_vpc.my_vpc.id
  name = "my-sg"
  description = "Allow ssh,http,mysql traffic"

  ingress  {
    protocol = "tcp"
    to_port = 22
    from_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    to_port = 80
    from_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    to_port = 3306
    from_port = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "icmp"
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    protocol = -1
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  #To explicitly declare first create VPC before creating SG
  depends_on = [ aws_vpc.my_vpc ]
}

#================================================================
#======================EC2 CONFIGURATIONS========================
#================================================================

#================================================================
#Public Server with public subnet

resource "aws_instance" "public-server" {
  subnet_id = aws_subnet.public_subnet.id
  ami = var.my_ami
  instance_type = var.my_instance_type
  key_name = var.my_key
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    Name = "App-Server"
  }
  depends_on = [ aws_security_group.my-sg ]
}

#================================================================
#Private Server with private subnet

resource "aws_instance" "private-server" {
  subnet_id = aws_subnet.private_subnet.id
  ami = var.my_ami
  instance_type = var.my_instance_type
  key_name = var.my_key
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    Name = "Application Server"
  }
  depends_on = [ aws_security_group.my-sg ]
}

#Private Server with private subnet-2

resource "aws_instance" "private-server-2" {
  subnet_id = aws_subnet.private_subnet_2.id
  ami = var.my_ami
  instance_type = var.my_instance_type
  key_name = var.my_key
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    Name = "DB-Server"
  }
  depends_on = [ aws_security_group.my-sg ]
}

