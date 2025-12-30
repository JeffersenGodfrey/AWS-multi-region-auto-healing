# Solution Summary

The solution implements an auto-healing, multi-region AWS architecture.

Failures are detected using:
- Application Load Balancer health checks
- Amazon CloudWatch metrics and alarms

Automated recovery is performed using:
- AWS Lambda for recovery logic
- AWS Systems Manager (SSM) for in-instance actions
- Auto Scaling Groups for instance replacement

## Autohealing Proof 
<img width="940" height="139" alt="image" src="https://github.com/user-attachments/assets/4e784847-fcda-46c3-95fe-b8430e18da06" />

<img width="940" height="347" alt="image" src="https://github.com/user-attachments/assets/2805ed47-2854-4f2d-bfa0-5cd7d9107608" />

For regional failures:
- Amazon Route 53 health checks redirect traffic to a secondary region


Data is stored using:
- Amazon DynamoDB Global Tables for serverless, multi-region availability
