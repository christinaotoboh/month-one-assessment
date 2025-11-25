#!/bin/bash

# Update system
yum update -y

# Install PostgreSQL
amazon-linux-extras install -y postgresql14

# Install PostgreSQL server
yum install -y postgresql-server postgresql-contrib

# Initialize database
postgresql-setup initdb

# Configure PostgreSQL to accept connections from VPC
cat >> /var/lib/pgsql/data/pg_hba.conf <<EOF

# Accept connections from VPC
host    all             all             10.0.0.0/16             md5
EOF

# Configure PostgreSQL to listen on all interfaces
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf

# Start PostgreSQL
systemctl start postgresql
systemctl enable postgresql

# Wait for PostgreSQL to start
sleep 10

# Create database and user
sudo -u postgres psql <<EOF
-- Create database
CREATE DATABASE techcorp_db;

-- Create user
CREATE USER techcorp_user WITH PASSWORD 'techcorp_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE techcorp_db TO techcorp_user;

-- Set postgres user password
ALTER USER postgres WITH PASSWORD 'techcorp_password';

-- Create a sample table
\c techcorp_db
CREATE TABLE app_info (
    id SERIAL PRIMARY KEY,
    app_name VARCHAR(100),
    version VARCHAR(20),
    deployment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO app_info (app_name, version) VALUES ('TechCorp Web App', '1.0.0');

-- Grant table privileges
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO techcorp_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO techcorp_user;
EOF

# Enable password authentication for SSH
echo "techcorp_db:TechCorp2024!" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Create ec2-user if doesn't exist and set password
if ! id "ec2-user" &>/dev/null; then
    useradd ec2-user
fi
echo "ec2-user:TechCorp2024!" | chpasswd

# Add ec2-user to sudoers
echo "ec2-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ec2-user

# Log completion
echo "PostgreSQL setup completed at $(date)" > /var/log/db-setup-complete.log