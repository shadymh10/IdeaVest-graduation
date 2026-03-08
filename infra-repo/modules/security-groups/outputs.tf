output "cluster_sg_id" {
  value = aws_security_group.eks_cluster.id
}

output "node_sg_id" {
  value = aws_security_group.eks_nodes.id
}
