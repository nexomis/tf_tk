resource "ovh_domain_zone_record" "subdomain" {
  for_each = var.subdomains

  zone    = "nexomis.io"
  subdomain = each.key
  fieldtype = "A"
  target   = each.value.ip
  ttl      = var.ttl
}


