# Create a VPC
resource "aws_vpc" "k8-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "k8s-dev-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "k8-subnet" {
  vpc_id     = aws_vpc.k8-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a" # desired AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "k8s-dev-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.k8-vpc.id
  tags = {
    Name = "k8s-dev-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.k8-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "k8s-dev-route-table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.k8-subnet.id
  route_table_id = aws_route_table.main.id
}

# Create a Security Group
resource "aws_security_group" "k8-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.k8-vpc.id

  tags = {
    Name = "k8-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "k8-sg_443" {
  security_group_id = aws_security_group.k8-sg.id
  cidr_ipv4         = aws_vpc.k8-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "k8-sg_80" {
  security_group_id = aws_security_group.k8-sg.id
  cidr_ipv4         = aws_vpc.k8-vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "k8-sg_22" {
  security_group_id = aws_security_group.k8-sg.id
  cidr_ipv4         = "185.241.227.168/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.k8-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Create a key pair
# resource "tls_private_key" "k8s_node" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
# resource "aws_key_pair" "k8s_node" {
#   key_name   = "k8s_node-key"
#   public_key = tls_private_key.k8s_node.public_key_openssh
# }

# resource "local_file" "private_key" {
#   filename        = "${aws_key_pair.k8s_node.key_name}.pem"
#   content         = tls_private_key.k8s_node.private_key_pem
#   file_permission = "0400"
# }

# resource "aws_key_pair" "k8s_node" {
#   key_name   = "k8s_node-key"
#   public_key = file("~/.ssh/id_rsa.pub")  
# }

# Create an EC2 Instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}


resource "aws_instance" "k8s_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.k8-subnet.id
  vpc_security_group_ids = [aws_security_group.k8-sg.id]
  key_name      = "KarlKey"

  tags = {
    Name = "k8s-node"
  }

  user_data = file("install_script.sh")

  provisioner "file" {
    source = "/Users/aideyancarlton/K8s-Nginx-app/K8-manifest"
    destination = "/home/ubuntu"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("/Users/aideyancarlton/Downloads/All Downloads/KarlKey.pem")
      host = aws_instance.k8s_node.public_ip
    }
  }
}

