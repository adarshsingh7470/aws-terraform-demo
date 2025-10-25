🚀 AWS Infrastructure using Terraform

This project demonstrates how to create and manage AWS infrastructure using Terraform.
The setup includes an EC2 instance, an S3 bucket, and an EFS (Elastic File System) — all provisioned automatically through Infrastructure as Code (IaC).

🧩 Project Overview

This Terraform project builds the following AWS resources:

Amazon EC2 Instance – A virtual machine running Amazon Linux 2.

Amazon S3 Bucket – Used for object storage.

Amazon EFS – A shared file system that can be mounted to EC2 instances.

Security Groups – For controlling inbound and outbound traffic.

User Data Script – Automatically installs and mounts EFS to the EC2 instance.

🏗️ Architecture Diagram
          ┌────────────────────┐
          │     S3 Bucket      │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │     EC2 Instance   │
          │  (Amazon Linux 2)  │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │        EFS         │
          └────────────────────┘

⚙️ Prerequisites

Before you begin, make sure you have:

Terraform
 installed (v1.0+)

AWS CLI configured with proper IAM permissions

aws configure


An AWS account with access to EC2, S3, and EFS services.

📂 Project Structure
aws-terraform-demo/
│
├── main.tf            # Main Terraform configuration
├── variables.tf       # Input variables
├── outputs.tf         # Output values (like EC2 public IP)
├── provider.tf        # AWS provider configuration
├── user_data.sh       # EC2 user data script (mounts EFS)
└── README.md          # Project documentation

🚀 How to Deploy
1. Initialize Terraform
terraform init

2. Validate the Configuration
terraform validate

3. Preview Changes
terraform plan

4. Apply the Configuration
terraform apply


Type yes when prompted to confirm the resource creation.

🔍 Verify Deployment

EC2 Instance: Check the instance in the AWS EC2 console.

S3 Bucket: Go to S3 in the AWS console to see your created bucket.

EFS: Confirm that the EFS file system exists and is mounted to your EC2 instance.

🧹 Cleanup

When you’re done testing, destroy all resources to avoid unwanted AWS charges:

terraform destroy

🧠 Key Concepts Used

Infrastructure as Code (IaC)

Terraform Providers and Resources

AWS EC2, S3, and EFS Services

User Data Automation Script

Security Group Configuration

💡 Future Improvements

Add VPC, Subnet, and Internet Gateway setup.

Automate instance connection using SSH key pairs.

Integrate with Jenkins for CI/CD Infrastructure Pipeline.

Add CloudWatch monitoring and alarms.

🧑‍💻 Author

Adarsh Singh
📍 Gwalior, India
💼 Aspiring DevOps Engineer