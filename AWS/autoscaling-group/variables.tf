variable "name" {
    description = "The name of the autoscaling group."
}

variable "iam_role" {
    description = "The name of the IAM role."
}

variable "project" {
    description = "The name of the project."
}

variable "instance_type" {
    description = "The type of the instance."
}

variable "backing_store" {
    description = "The backing store of the instance."
    default     = "hvm:ebs-ssd:amazon2"
}

variable "vpc_id" {
    description = "The VPC id."
}

variable "subnet_type" {
    description = "The tyoe of the subnet to launch instances in. Only allowed values are 'private' and 'public'."
    default     = "public"
}

variable "availability_zones" {
    description = "A list of availability zones to launch resources in."
    default     = ["us-east-1a", "us-east-1c"]
}

variable "security_groups" {
    description = "A list of security groups associated with the service."
    type        = list(string)
}

variable "min_size" {
    description = "The minimum number of instances."
}

variable "max_size" {
    description = "The maximum number of instances."
}

variable "desire_capacity" {
    description = "The number of Amazon EC2 instances that should be running in the group."
    default     = 0
}

variable "key_name" {
    description = "SSH key name."
    default     = ""
}

variable "instance_domain_name" {
    description = "Domain name used to form the FQDN for the instance."
}

variable "tags" {
    description = "Tags to set on each launched instance."
    type        = map(any)
    default     = {}
}

