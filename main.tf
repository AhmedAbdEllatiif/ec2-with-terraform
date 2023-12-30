

# --------------------------------------------------------------------------------------
# Networking
# --------------------------------------------------------------------------------------
#
#
#
#
#
#
### 1: Create Vpc
resource "aws_vpc" "app_vpc" {
    cidr_block = var.cidr_blocks[0]
    tags =  {
            Name:  "${var.env_prefix}-vpc"
        }
}
#
#
#
#
#
#
#
### 2: Create Subnet inside the created vpc
resource "aws_subnet" "app_subnet"{
    vpc_id  = aws_vpc.app_vpc.id
    cidr_block = var.cidr_blocks[1]
    availability_zone = var.az_name
    tags =  {
            Name: "${var.env_prefix}-subnet"
        }
}
#
#
#
#
#
#
#
### 3: Create Internet Gateway to be attached to the vpc 
resource "aws_internet_gateway" "app_gateway"{
    vpc_id  = aws_vpc.app_vpc.id

    tags = {
           Name: "${var.env_prefix}-igw"
    }
}
#
#
#
#
#
#
### 4: Create Route Table with 
resource "aws_route_table" "app_route_table"{
     vpc_id  = aws_vpc.app_vpc.id

     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app_gateway.id
     }

     tags= {
           Name: "${var.env_prefix}-route-table"
    }
}
#
#
#
#
#
#
### 5: Create subent association between Route_Table and Subnet
resource "aws_route_table_association" "app_rt_assciation" {
    subnet_id = aws_subnet.app_subnet.id
    route_table_id = aws_route_table.app_route_table.id
}
#
#
#
#
#
#
### 6: Create Security Group (use the default that already created with vpc)
resource "aws_default_security_group" "default_sg" {
    vpc_id  = aws_vpc.app_vpc.id

    #>> ssh  
    ingress {
        from_port = 22
        to_port = 22
        protocol= "tcp"
        # you can explicitly define the ip range that can access ssh
        # ex. "your-machine-ip/32" to only access with one ip 
        cidr_blocks = [var.my_ip]
    }

    
    # outbound for all
    egress {
        from_port = 0
        to_port = 0
        protocol= "-1" # allow any protocl 
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = [] # allow to access vpc endpoints
    }

    tags= {
        Name: "${var.env_prefix}-sg"
        }
}

#
#
#
#
#
#
#
# --------------------------------------------------------------------------------------
# instance 
# --------------------------------------------------------------------------------------
#
#
#
#
#
#
### 7: Fetch the AMI 
data "aws_ami" "ubuntu_latest" {
    most_recent  = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}
#
#
#
#
#
#
### 8: Create ssh public key
resource "aws_key_pair" "ssh_key"{
  key_name = "server_shh_key"
  public_key = file(var.public_ssh_key)

}
#
#
#
#
#
#
### 9: And Finally create the Ec2 instance 
resource "aws_instance" "app_server"{
    #>> network
    subnet_id = aws_subnet.app_subnet.id
    availability_zone = var.az_name
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_default_security_group.default_sg.id]
    
    #>> AMI & instance type 
    ami = data.aws_ami.ubuntu_latest.id
    instance_type = var.instance_type

    #>> key pair 
    key_name = aws_key_pair.ssh_key.key_name
   

    tags = {
        Name: "${var.env_prefix}-instance"
    }
}

