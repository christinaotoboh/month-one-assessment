output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_eip.bastion.public_ip
}

output "web_server_1_private_ip" {
  description = "Private IP of web server 1"
  value       = aws_instance.web_1.private_ip
}

output "web_server_2_private_ip" {
  description = "Private IP of web server 2"
  value       = aws_instance.web_2.private_ip
}

output "database_private_ip" {
  description = "Private IP of database server"
  value       = aws_instance.database.private_ip
}

output "connection_instructions" {
  description = "Instructions for connecting to instances"
  value       = <<-EOT
    
    === CONNECTION INSTRUCTIONS ===
    
    1. Connect to Bastion Host:
       ssh -i ${var.key_pair_name}.pem ec2-user@${aws_eip.bastion.public_ip}
       OR with password:
       ssh ec2-user@${aws_eip.bastion.public_ip}
       Password: (use the admin_password you set)
    
    2. From Bastion, connect to Web Server 1:
       ssh ec2-user@${aws_instance.web_1.private_ip}
    
    3. From Bastion, connect to Web Server 2:
       ssh ec2-user@${aws_instance.web_2.private_ip}
    
    4. From Bastion, connect to Database Server:
       ssh ec2-user@${aws_instance.database.private_ip}
    
    5. Access the web application:
       http://${aws_lb.web.dns_name}
    
    6. Connect to PostgreSQL from web servers:
       psql -h ${aws_instance.database.private_ip} -U postgres -d techcorp_db
       Password: techcorp_password
  EOT
}