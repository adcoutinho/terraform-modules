variable "tcp_ports" {
  description = "A dictionary of TCP ports and CIDRs to be allowed"
  type = map(any)
  default = {}
}

variable "udp_ports" {
  description = "A dictionary of UDP ports and CIDRs to be allowed"
  type = map(any)
  default = {}
}

variable "tags" {
    description = "Tags to set on each launched SG."
    type        = map(any)
    default     = {}
}