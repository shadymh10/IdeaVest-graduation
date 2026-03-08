aws_region             = "us-east-1"
project_name           = "coolad"
environment            = "dev"

# Networking - 2 AZs
vpc_cidr               = "10.0.0.0/16"
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
database_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]
availability_zones     = ["us-east-1a", "us-east-1b"]
allowed_ssh_cidrs      = ["0.0.0.0/0"]

# EC2 - Free Tier
ami_id                 = "ami-0c02fb55956c7d316"
jenkins_instance_type  = "t2.micro"
app_instance_type      = "t2.micro"
ssh_public_key         = "ssh-rsa CHANGEME"
asg_desired            = 1
asg_min                = 1
asg_max                = 2

# Database - Free Tier
db_username            = "coolad_admin"
db_password            = "CHANGE_ME_SECURE_PASSWORD"

# EKS
eks_cluster_version    = "1.28"
node_instance_type     = "t3.small"
node_desired_count     = 2
node_min_count         = 1
node_max_count         = 2
