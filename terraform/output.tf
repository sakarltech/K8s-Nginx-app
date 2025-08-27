output "public_ip" {
  value = aws_instance.k8s_node.public_ip
}

output "vpc_id" {
  value = aws_vpc.k8-vpc.id
}