output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public_rt.id
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "primary_alb_dns" {
  # The primary ALB is declared as `web_alb` in alb.tf
  value = aws_lb.web_alb.dns_name
}

output "secondary_alb_dns" {
  value = aws_lb.secondary_alb.dns_name
}


