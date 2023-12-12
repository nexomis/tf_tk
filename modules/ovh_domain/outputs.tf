output "subdomain_records" {
  description = "The created subdomain records"
  value = [for record in ovh_domain_zone_record.subdomain : {
    subdomain = record.subdomain
    ip        = record.target
    ttl       = record.ttl
  }]
}