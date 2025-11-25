#!/bin/bash

# Update system
yum update -y

# Install Apache
yum install -y httpd

# Get instance metadata
INSTANCE_ID=$(ec2-metadata --instance-id | cut -d " " -f 2)
PRIVATE_IP=$(ec2-metadata --local-ipv4 | cut -d " " -f 2)
AVAILABILITY_ZONE=$(ec2-metadata --availability-zone | cut -d " " -f 2)

# Create HTML page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechCorp Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
        }
        .info {
            background-color: #ecf0f1;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .label {
            font-weight: bold;
            color: #2c3e50;
        }
        .value {
            color: #3498db;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 TechCorp Web Application</h1>
        <p>Welcome to TechCorp's highly available web infrastructure!</p>
        
        <div class="info">
            <p><span class="label">Server Name:</span> <span class="value">${instance_name}</span></p>
            <p><span class="label">Instance ID:</span> <span class="value">$INSTANCE_ID</span></p>
            <p><span class="label">Private IP:</span> <span class="value">$PRIVATE_IP</span></p>
            <p><span class="label">Availability Zone:</span> <span class="value">$AVAILABILITY_ZONE</span></p>
            <p><span class="label">Timestamp:</span> <span class="value">$(date)</span></p>
        </div>
        
        <p>✅ This server is behind an Application Load Balancer</p>
        <p>✅ Running in a private subnet</p>
        <p>✅ Part of a highly available architecture</p>
    </div>
</body>
</html>
EOF

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Enable password authentication for SSH
echo "techcorp_web:TechCorp2024!" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Create ec2-user if doesn't exist and set password
if ! id "ec2-user" &>/dev/null; then
    useradd ec2-user
fi
echo "ec2-user:TechCorp2024!" | chpasswd

# Add ec2-user to sudoers
echo "ec2-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ec2-user