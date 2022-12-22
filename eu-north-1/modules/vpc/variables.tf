variable "ipv4_address" {
  type        = string
  description = "The IPv4 address of the VPC"
  default     = "192.168.0.0"
}

variable "ipv4_mask" {
  type        = number
  description = "The IPv4 mask of the VPC"
  default     = 16
}
