variable "hosts" {
  description = "List of dictionaries with host details"
  type = list(object({
    host_ip        : string
    inventory_name : string
    ansible_user   : string
    pem_string     : string
  }))
}

variable "ansible_dir" {
  description = "Ansible root directory"
  type        = string
}