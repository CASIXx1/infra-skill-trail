variable "name" {
  description = "Name prefix for VPC endpoint resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for interface endpoints."
  type        = list(string)
}

variable "private_route_table_id" {
  description = "Private route table ID for the S3 gateway endpoint."
  type        = string
}

variable "interface_endpoint_security_group_id" {
  description = "Security group ID attached to interface VPC endpoints."
  type        = string
}
