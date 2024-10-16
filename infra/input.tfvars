project_id = "abhiwa-test-30112023"
region     = "us-central1"

three_tier_app_cache_name                    = "redis-instance"
three_tier_app_cache_redis_version           = "REDIS_6_X"
three_tier_app_cache_connect_mode            = "DIRECT_PEERING"
three_tier_app_cache_tier                    = "BASIC"
three_tier_app_cache_transit_encryption_mode = "DISABLED"

three_tier_app_database_db_name                  = "database"
three_tier_app_database_name                     = "database-instance"
three_tier_app_database_database_version         = "POSTGRES_14"
three_tier_app_database_database_flags           = [{ name : "cloudsql.iam_authentication", value : "on" }]
three_tier_app_database_deletion_protection      = false
three_tier_app_database_user_deletion_policy     = "ABANDON"
three_tier_app_database_database_deletion_policy = "ABANDON"
three_tier_app_database_enable_default_user      = false
three_tier_app_database_ip_configuration         = { ipv4_enabled : false }

backend_startup_script = <<-EOF
    apt-get update
    apt-get install -y docker.io
    gcloud auth configure-docker
    docker pull gcr.io/abhiwa-test-30112023/three-tier-app-be:1.0.2
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
    docker run -e PORT="8080" --env-file /tmp/docker-env.txt -d --network host --name backend-service gcr.io/abhiwa-test-30112023/three-tier-app-be:1.0.2
EOF