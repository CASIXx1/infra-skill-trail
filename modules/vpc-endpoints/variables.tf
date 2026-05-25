variable "name" {
  description = "Name prefix for VPC endpoint resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block allowed to access interface endpoints."
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
