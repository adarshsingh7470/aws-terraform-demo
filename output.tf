output "instance_id" {
  value = aws_instance.demo_server.id

}

output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket

}

output "ec2_public_ip" {
  value       = aws_instance.demo_server.public_ip
  description = "public IP of the EC2 instance"

}

output "efs_id" {
  value       = aws_efs_file_system.main.id
  description = "ID of the EFS file system"

}

output "efs_dns_name" {
  value       = aws_efs_file_system.main.dns_name
  description = "DNS name of the EFS file system"

}

output "ssh_command" {
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.demo_server.public_ip}"
  description = "Command to SSH into the EC2 instance"

}

output "test_efs_command" {
  value       = "After ssh, run: cat /mnt/efs/test.txt"
  description = "Command to test mounting the EFS on the EC2 instance"

}