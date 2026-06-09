variable "name" {
  description = "Name prefix for FireLens config resources."
  type        = string
}

variable "config_object_key" {
  description = "S3 object key for the FireLens Fluent Bit config."
  type        = string
  default     = "firelens/fluent-bit.conf"
}

variable "config_content" {
  description = "FireLens Fluent Bit custom config content."
  type        = string
  default     = <<-EOT
    [FILTER]
        Name rewrite_tag
        Match *-firelens*
        Rule $level ^error$ app_error false
        Rule $level ^(debug|info|warn)$ app_normal false

    [OUTPUT]
        Name cloudwatch_logs
        Match app_normal
        region $${AWS_REGION}
        log_group_name $${CLOUDWATCH_LOG_GROUP}
        log_stream_prefix api/
        auto_create_group false

    [OUTPUT]
        Name newrelic
        Match app_error
        endpoint $${NEW_RELIC_LOG_ENDPOINT}
        apiKey $${NEW_RELIC_API_KEY}
  EOT
}
