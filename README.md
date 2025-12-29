# Multi-Region Auto-Healing Web Infrastructure using AWS & Terraform

## Overview

This project demonstrates a multi-region, auto-healing web infrastructure on AWS designed to maintain application availability during instance-level and regional failures.

The system uses Terraform for infrastructure automation and AWS managed services to enable automatic recovery, load balancing, and DNS-based traffic routing.

Backend services are implemented in a single primary region, while frontend infrastructure is deployed across multiple regions to improve availability and resilience.

## Key Features

- Auto-healing EC2 instances using Auto Scaling Groups
- Load-balanced web traffic via Application Load Balancer (ALB)
- Multi-region architecture with Route 53 DNS routing
- Infrastructure provisioning using Terraform
- Backend services hosted in a single region (intentional design)
- Cost-aware and interview-safe architecture

## Architecture Summary

### Global Layer

- Amazon Route 53
  - Acts as a global DNS
  - Routes traffic to the healthy region
  - Enables future failover routing

### Primary Region (North Virginia – us-east-1)

#### Frontend (Terraform Managed)

- Virtual Private Cloud (VPC)
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- EC2 Web Servers

#### Backend (Created via AWS Console)

- Amazon API Gateway
- AWS Lambda
- Amazon DynamoDB (Global Tables enabled)

This region hosts both frontend and backend, making it the active region.

### Secondary Region

#### Frontend Only (Terraform Managed)

- Virtual Private Cloud (VPC)
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- EC2 Web Servers

No backend services are deployed in this region.

The secondary region is used to:
- Serve frontend traffic
- Demonstrate multi-region readiness
- Act as a failover entry point via Route 53

## Auto-Healing Mechanism

- User sends a request via Route 53 DNS
- Traffic reaches the Application Load Balancer
- ALB performs health checks on EC2 instances
- If an EC2 instance becomes unhealthy:
  - Auto Scaling Group terminates the instance
  - A new instance is launched automatically
- Traffic is routed only to healthy instances

This ensures zero manual intervention for instance-level failures.

## Backend Design Decision

Backend services (API Gateway, Lambda, DynamoDB) are deployed only in the primary region.

This was a conscious scope and cost decision. The secondary region focuses on infrastructure resilience, not backend duplication.

### Why This Design

- Simple and clear architecture
- Cost-efficient
- Realistic for learning, demos, and interviews

## Infrastructure as Code (Terraform)

Terraform was used to provision:

- VPCs
- Subnets
- Application Load Balancers
- Auto Scaling Groups
- EC2 Instances

### Why Backend Was Not Managed via Terraform

- Reduce Terraform complexity
- Focus on core infrastructure automation
- Avoid over-engineering for a learning project

## AWS Services Used

- Amazon EC2
- Amazon VPC
- Auto Scaling Group
- Application Load Balancer (ALB)
- Amazon Route 53
- AWS Lambda
- Amazon API Gateway
- Amazon DynamoDB (Global Tables)

## Limitations and Future Improvements

### Current Limitations

- Backend deployed in a single region
- No automated backend failover

### Future Enhancements

- Replicate API Gateway and Lambda in the secondary region
- Implement Route 53 failover routing
- Manage backend services using Terraform

## Documentation

Detailed architecture diagrams, implementation steps, and proof screenshots are available in:

docs/Project_Report.pdf


> Note: Infrastructure is created only for testing and is destroyed after validation to optimize cost.
