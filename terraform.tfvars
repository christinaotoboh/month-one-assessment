# Copy this file to terraform.tfvars and update with your values

aws_region = "us-east-1"

# Your EC2 key pair name (must exist in AWS)
key_pair_name = "nginx-key"

# Your public IP address for SSH access (format: x.x.x.x/32)
# Find yours at: https://whatismyipaddress.com/
my_ip = "1.2.3.4/32"

# Password for SSH password authentication
admin_password = "YourSecurePassword123!"

# Instance types (optional, defaults are set)
# bastion_instance_type = "t3.micro"
# web_instance_type = "t3.micro"
# db_instance_type = "t3.small"

