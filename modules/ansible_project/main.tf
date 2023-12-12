resource "local_sensitive_file" "pem_file" {
  for_each = { for h in var.hosts : h.inventory_name => h }
  file_permission = "0600"
  content = each.value.pem_string
  filename          = "${var.ansible_dir}/privates/${each.value.inventory_name}.pem"
}

resource "local_file" "inventory_file" {
  content = "${"[EC2]\n"}${join("\n", [for h in var.hosts : "${h.inventory_name} ansible_host=${h.host_ip} ansible_user=${h.ansible_user} ansible_ssh_private_key_file=./privates/${h.inventory_name}.pem"])}\n"
  filename = "${var.ansible_dir}/inventory"
}