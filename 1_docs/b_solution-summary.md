# Solution Summary

The solution implements an auto-healing, multi-region AWS web architecture.
Failures are detected using:

- Application Load Balancer target group health checks
- EC2 instance health status evaluated by Auto Scaling Groups
- Automated recovery is performed using:
- Auto Scaling Groups to terminate unhealthy instances
- Automatic EC2 instance replacement without manual intervention
- Route 53 DNS routing to enable multi-region traffic entry

## Autohealing Proof 
<img width="940" height="139" alt="image" src="https://github.com/user-attachments/assets/4e784847-fcda-46c3-95fe-b8430e18da06" />

<img width="940" height="347" alt="image" src="https://github.com/user-attachments/assets/2805ed47-2854-4f2d-bfa0-5cd7d9107608" />

For regional failures:
- Amazon Route 53 health checks redirect traffic to a secondary region


Data is stored using:
- Amazon DynamoDB Tables for storing data in tables. 
