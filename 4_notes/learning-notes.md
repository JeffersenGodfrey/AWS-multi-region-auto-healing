# Learning Notes

## 1. VPC Creation

- Created a custom VPC
- Enabled DNS Hostnames and DNS Resolution
- CIDR block configured (10.0.0.0/16)

2. Subnet Configuration

Created two public subnets in different Availability Zones

Enabled Auto-assign Public IPv4 for subnets

Associated subnets with a public route table

3. Internet Gateway & Routing

Created an Internet Gateway

Attached it to the VPC

Added route 0.0.0.0/0 → Internet Gateway in route table

4. Security Groups

Created EC2 Security Group

Allowed HTTP (80) from ALB Security Group

Allowed SSH (22) for admin access (limited)

Created ALB Security Group

Allowed inbound HTTP (80) from anywhere

Ensured correct SG-to-SG referencing

5. EC2 Launch Template

Created Launch Template for web server

Selected Amazon Linux AMI

Attached EC2 security group

Added User Data to install and start web server

Enabled IAM role for EC2 (SSM access only)

6. Auto Scaling Group (ASG)

Created ASG using the launch template

Selected multiple public subnets

Set desired capacity = 1

Enabled EC2 + ELB health checks

Configured health check grace period

7. Application Load Balancer (ALB)

Created Application Load Balancer

Selected public subnets

Attached ALB security group

Created target group with HTTP health checks

Connected ALB to Auto Scaling Group

8. Health Check Validation

Verified targets are healthy in target group

Tested ALB DNS in browser

Confirmed traffic routing through ALB

9. Auto-Healing Test

Manually terminated EC2 instance

Observed ASG launching a new instance

Verified ALB routes traffic to new instance

Confirmed zero manual intervention

10. Backend – DynamoDB

Created DynamoDB table

Defined partition key

Verified table creation

11. Backend – AWS Lambda

Created Lambda function (Python)

Added DynamoDB write permissions

Connected Lambda to DynamoDB table

Tested Lambda execution

12. Backend – API Gateway

Created REST API

Created /create POST method

Integrated with Lambda

Deployed API to a stage

Verified Invoke URL

13. Backend Validation

Tested API from EC2 using curl

Confirmed data insertion into DynamoDB

Verified Lambda logs in CloudWatch

14. Route 53 Configuration

Created Hosted Zone

Added record pointing to ALB DNS

Verified DNS resolution in browser

15. Multi-Region Setup (Console + Terraform)

Recreated frontend infrastructure in second region

Validated ALB and ASG health

Ensured backend remains in primary region only

16. Cost Control

No NAT Gateway used

Used public subnets with auto-assign public IP

Destroyed infrastructure after validation

## Rough Sketch 
![WhatsApp Image 2025-12-31 at 5 42 20 PM](https://github.com/user-attachments/assets/8f5b1831-ba10-40c3-a9be-9b7a26d16afe)

