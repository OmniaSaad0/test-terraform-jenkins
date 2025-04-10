output "rds_hostname" {
  value = aws_db_instance.db.address
}

output "rds_port" {
  value = aws_db_instance.db.port
}

output "redis_hostname" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.redis.port
}
