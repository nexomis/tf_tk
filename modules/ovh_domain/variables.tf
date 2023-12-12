variable "subdomains" {
  description = "A map of subdomains and their corresponding IP addresses"
  type = map(object({
    ip = string
  }))
}

variable "ttl" {
  description = "The TTL for the DNS record"
  type        = number
  default     = 3600
}
