# TechCorp AWS Infrastructure Deployment Guide

This repository contains Terraform configurations to deploy a highly available, secure web application infrastructure on AWS.

## 📋 Architecture Overview

This infrastructure includes:
- **VPC** with public and private subnets across 2 availability zones
- **Internet Gateway** for public internet access
- **NAT Gateways** (2) for private subnet internet access
- **Application Load Balancer** distributing traffic to web servers
- **Bastion Host** for secure administrative access
- **Web Servers** (2) running Apache in private subnets
- **Database Server** running PostgreSQL in private subnet
- **Security Groups** implementing least-privilege access

## 🔧 Prerequisites

Before deploying, ensure you have:

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```
3. **Terraform** installed (v1.0 or later)
   ```bash
   # Check version
   terraform version
   ```
4. **SSH Key Pair** created in AWS EC2
   - Go to EC2 Console → Key Pairs → Create Key Pair
   - Download and save the `.pem` file
   - Set permissions: `chmod 400 your-key.pem`
5. **Your Public IP Address**
   - Find it at: https://whatismyipaddress.com/

## 📁 Project Structure

```
terraform-assessment/
├── main.tf                          # Main infrastructure definitions
├── variables.tf                     # Variable declarations
├── outputs.tf                       # Output definitions
├── terraform.tfvars.example         # Example variable values
├── user_data/
│   ├── web_server_setup.sh         # Web server configuration script
│   └── db_server_setup.sh          # Database server configuration script
└── README.md                        # This file
```

## 🚀 Deployment Steps

### Step 1: Clone and Prepare

```bash
# Create project directory
mkdir terraform-assessment
cd terraform-assessment

# Create user_data directory
mkdir user_data

# Copy all configuration files to appropriate locations
```

### Step 2: Configure Variables

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
nano terraform.tfvars
```

Update the following values:
```hcl
aws_region    = "us-east-1"
key_pair_name = "your-key-pair-name"
my_ip         = "YOUR.IP.ADDRESS/32"
admin_password = "YourSecurePassword123!"
```

### Step 3: Initialize Terraform

```bash
# Initialize Terraform (downloads providers)
terraform init
```

Expected output: "Terraform has been successfully initialized!"

### Step 4: Review the Plan

```bash
# See what will be created
terraform plan

# Optional: Save the plan
terraform plan -out=tfplan
```

This shows all resources that will be created. Review carefully!

### Step 5: Deploy Infrastructure

```bash
# Apply the configuration
terraform apply

# Or if you saved a plan:
terraform apply tfplan
```

Type `yes` when prompted. Deployment takes 5-10 minutes.

### Step 6: Capture Outputs

After successful deployment:

```bash
# View all outputs
terraform output

# Save outputs to file
terraform output > deployment-outputs.txt
```

Key outputs:
- `vpc_id`: VPC identifier
- `load_balancer_dns`: URL to access your web application
- `bastion_public_ip`: IP to connect to bastion host
- `connection_instructions`: Step-by-step connection guide

## 🔐 Accessing Your Infrastructure

### Connect to Bastion Host

**Option 1: Using SSH Key**
```bash
ssh -i your-key.pem ec2-user@<BASTION_PUBLIC_IP>
```

**Option 2: Using Password**
```bash
ssh ec2-user@<BASTION_PUBLIC_IP>
# Password: TechCorp2024! (or your custom admin_password)
```

### Connect to Web Servers (from Bastion)

```bash
# Web Server 1
ssh ec2-user@<WEB_SERVER_1_PRIVATE_IP>

# Web Server 2
ssh ec2-user@<WEB_SERVER_2_PRIVATE_IP>

# Password for both: TechCorp2024!
```

### Connect to Database Server (from Bastion)

```bash
# SSH to database server
ssh ec2-user@<DATABASE_PRIVATE_IP>
# Password: TechCorp2024!

# Once connected, access PostgreSQL
sudo -u postgres psql
# Or with password authentication:
psql -h localhost -U postgres -d techcorp_db
# Password: techcorp_password
```

### Access Web Application

Open your browser and navigate to:
```
http://<LOAD_BALANCER_DNS>
```

Refresh the page multiple times to see traffic distributed between servers.

## 🧪 Testing Your Deployment

### 1. Test Load Balancer
```bash
# From your local machine
curl http://<LOAD_BALANCER_DNS>

# Multiple requests to see load balancing
for i in {1..10}; do curl -s http://<LOAD_BALANCER_DNS> | grep "Instance ID"; done
```

### 2. Test Bastion Access
```bash
# Connect to bastion
ssh -i your-key.pem ec2-user@<BASTION_PUBLIC_IP>

# From bastion, ping web servers
ping <WEB_SERVER_1_PRIVATE_IP>
ping <WEB_SERVER_2_PRIVATE_IP>
```

### 3. Test Database Connectivity
```bash
# SSH to web server from bastion
ssh ec2-user@<WEB_SERVER_1_PRIVATE_IP>

# Install PostgreSQL client
sudo yum install -y postgresql

# Connect to database
psql -h <DATABASE_PRIVATE_IP> -U postgres -d techcorp_db
# Password: techcorp_password

# Query sample data
SELECT * FROM app_info;

# Exit
\q
```

### 4. Test Web Server Status
```bash
# SSH to web server
ssh ec2-user@<WEB_SERVER_1_PRIVATE_IP>

# Check Apache status
sudo systemctl status httpd

# View Apache logs
sudo tail -f /var/log/httpd/access_log
```

## 📸 Screenshots Required

Capture the following for your submission:

1. **Terraform Plan Output**
   ```bash
   terraform plan | tee plan-output.txt
   ```

2. **Terraform Apply Completion**
   - Screenshot showing "Apply complete!" message
   - Show resource count created

3. **AWS Console - VPC Dashboard**
   - Show created VPC, subnets, route tables, NAT gateways

4. **AWS Console - EC2 Instances**
   - Show all 4 running instances (bastion, 2 web, 1 db)

5. **AWS Console - Load Balancer**
   - Show ALB with target group health

6. **Browser - Web Application**
   - Access http://<LOAD_BALANCER_DNS>
   - Show instance ID in the page
   - Refresh and capture different instance

7. **SSH - Bastion Connection**
   ```bash
   ssh -i your-key.pem ec2-user@<BASTION_PUBLIC_IP>
   hostname
   ```

8. **SSH - Web Server Connection**
   ```bash
   # From bastion
   ssh ec2-user@<WEB_PRIVATE_IP>
   hostname
   sudo systemctl status httpd
   ```

9. **SSH - Database Server Connection**
   ```bash
   # From bastion
   ssh ec2-user@<DB_PRIVATE_IP>
   hostname
   sudo systemctl status postgresql
   ```

10. **PostgreSQL Connection**
    ```bash
    psql -h <DB_PRIVATE_IP> -U postgres -d techcorp_db
    \l  # List databases
    \dt # List tables
    SELECT * FROM app_info;
    ```

## 🧹 Cleanup (Destroy Infrastructure)

When you're done testing:

### Step 1: Review Resources to be Destroyed
```bash
terraform plan -destroy
```

### Step 2: Destroy Infrastructure
```bash
terraform destroy
```

Type `yes` when prompted. This removes all created resources.

### Step 3: Verify Cleanup
```bash
# Check AWS Console to ensure all resources are gone
# Resources to check:
# - EC2 instances terminated
# - NAT Gateways deleted
# - Elastic IPs released
# - Load Balancer deleted
```

**⚠️ Important Cleanup Notes:**
- NAT Gateways incur hourly charges - ensure they're deleted
- Elastic IPs cost money when not attached - verify release
- Some resources may take a few minutes to fully delete

## 💰 Cost Considerations

Approximate hourly costs (us-east-1):
- NAT Gateways (2): ~$0.09/hour
- EC2 Instances (4): ~$0.06/hour
- Application Load Balancer: ~$0.025/hour
- Data transfer: Variable

**Total: ~$0.175/hour or ~$125/month**

**Cost Savings Tips:**
- Destroy infrastructure when not in use
- Use smaller instance types for testing
- Consider single NAT Gateway (reduces HA)

## 🔧 Troubleshooting

### Issue: Terraform init fails
```bash
# Solution: Check internet connection and AWS credentials
aws sts get-caller-identity
```

### Issue: Can't SSH to bastion
```bash
# Check your IP is correct
curl https://api.ipify.org

# Update terraform.tfvars with correct IP
my_ip = "YOUR.NEW.IP/32"

# Apply changes
terraform apply
```

### Issue: Load balancer shows unhealthy targets
```bash
# Wait 2-3 minutes for user data scripts to complete
# Check instance logs:
ssh -i your-key.pem ec2-user@<BASTION_IP>
ssh ec2-user@<WEB_PRIVATE_IP>
sudo tail -f /var/log/cloud-init-output.log
```

### Issue: Can't connect to PostgreSQL
```bash
# Verify PostgreSQL is running
ssh ec2-user@<DB_PRIVATE_IP>
sudo systemctl status postgresql

# Check PostgreSQL logs
sudo tail -f /var/lib/pgsql/data/log/postgresql-*.log
```

### Issue: Password authentication not working
```bash
# Check SSH configuration
sudo cat /etc/ssh/sshd_config | grep PasswordAuthentication

# Should show: PasswordAuthentication yes
# If not, restart sshd:
sudo systemctl restart sshd
```

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🔒 Security Best Practices

1. **Never commit terraform.tfvars** with real credentials
2. **Rotate passwords** regularly
3. **Use AWS Secrets Manager** for production passwords
4. **Enable MFA** on AWS accounts
5. **Review Security Group rules** regularly
6. **Use Systems Manager Session Manager** instead of bastion in production
7. **Enable VPC Flow Logs** for network monitoring
8. **Implement AWS CloudTrail** for audit logging

## 📝 State File Management

The `terraform.tfstate` file contains:
- All resource IDs and configurations
- Sensitive data (passwords may be visible)

**For this assessment:**
```bash
# Export state file
cp terraform.tfstate terraform.tfstate.backup

# Review for sensitive data
grep -i password terraform.tfstate
```

**For production:**
- Use remote state (S3 + DynamoDB)
- Enable state encryption
- Implement state locking
- Never commit state files to Git

## 🎯 Assessment Checklist

- [ ] All Terraform files created
- [ ] Infrastructure deploys successfully
- [ ] Can SSH to bastion host
- [ ] Can SSH to web servers from bastion
- [ ] Can SSH to database from bastion
- [ ] Load balancer serves web pages
- [ ] Web pages show different instance IDs
- [ ] Can connect to PostgreSQL
- [ ] All screenshots captured
- [ ] State file exported
- [ ] README documentation complete
- [ ] Infrastructure destroyed after testing

## 📧 Support

For issues or questions:
1. Review error messages carefully
2. Check AWS Console for resource status
3. Review Terraform documentation
4. Check CloudWatch logs for instance issues

---

**Created for TechCorp Infrastructure Assessment**  
**Last Updated:** November 2025