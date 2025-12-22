# Terraform Three-Tier AWS Infrastructure Setup

## Description

This project demonstrates how to provision a basic three-tier infrastructure on AWS using Terraform. It includes creating a custom VPC, public and private subnets, Internet Gateway, NAT Gateway, route tables, security groups, and multiple EC2 instances. The setup represents a common real-world architecture with a public bastion/application server and private application and database servers.

---

## Architecture Overview

The infrastructure is deployed using Terraform and follows a layered network design:

- A custom VPC with defined CIDR blocks
- One public subnet for external access
- Two private subnets for application and database servers
- Internet Gateway for public connectivity
- NAT Gateway for outbound internet access from private subnets
- Route tables to control traffic flow
- Security group allowing SSH, HTTP, MySQL, and ICMP
- Three EC2 instances deployed across public and private subnets

This setup helps in understanding network isolation, secure access patterns, and Infrastructure as Code principles.

---

## ASCII Architecture Diagram

```

```
             Internet
                 |
           +-------------+
           | Internet GW |
           +------+------+
                  |
          +-------+-------+
          |   Public Subnet|
          |  (Bastion/App)|
          +-------+-------+
                  |
            +-----+-----+
            |  NAT Gateway|
            +-----+-----+
                  |
    +-------------+-------------+
    |                           |
```

+---------------+         +----------------+
| Private Subnet |         | Private Subnet |
| Application    |         | Database       |
| Server         |         | Server         |
+---------------+         +----------------+

````

---

## Prerequisites

- Terraform installed on local machine
- AWS CLI installed and configured
- AWS account with permissions for EC2, VPC, IAM, and S3
- Existing S3 bucket for Terraform backend
- Basic understanding of AWS networking concepts

---

## Terraform Components Used

- AWS Provider
- S3 Backend for state management
- VPC
- Public and Private Subnets
- Internet Gateway
- Elastic IP
- NAT Gateway
- Route Tables and Associations
- Security Groups
- EC2 Instances

---

## Execution Steps

### Step 1: Initialize Terraform

```bash
terraform init
````

This initializes the working directory and configures the S3 backend.

---

### Step 2: Validate and Review Plan

```bash
terraform plan
```

This shows the resources that will be created.

---

### Step 3: Apply Configuration

```bash
terraform apply --auto-approve
```

Terraform provisions the complete infrastructure on AWS.

---

### Step 4: Verify Resources

* Check VPC, subnets, route tables, and gateways in AWS Console
* Verify EC2 instances are launched in correct subnets
* Confirm NAT Gateway and Internet Gateway routing

---

### Step 5: Destroy Infrastructure

```bash
terraform destroy --auto-approve
```

This removes all Terraform-managed resources.

---

## Key Learnings

* Designing VPC networking using Terraform
* Implementing public and private subnet isolation
* Configuring NAT Gateway for private subnet internet access
* Managing route tables and traffic flow
* Provisioning EC2 instances securely
* Using S3 backend for Terraform state management

---

## Summary

| Component        | Purpose                                 |
| ---------------- | --------------------------------------- |
| VPC              | Isolated network environment            |
| Public Subnet    | External access and bastion/application |
| Private Subnets  | Secure application and database layers  |
| Internet Gateway | Internet access for public subnet       |
| NAT Gateway      | Outbound internet for private subnets   |
| Security Group   | Controlled access rules                 |
| EC2 Instances    | Application and database servers        |

---

## Contact

Author: Kunal Shinde

Email: [kunalshinde066@gmail.com](mailto:kunalshinde066@gmail.com)

LinkedIn: [https://www.linkedin.com/in/kunal-shinde-1b17a2205](https://www.linkedin.com/in/kunal-shinde-1b17a2205)

```

---
