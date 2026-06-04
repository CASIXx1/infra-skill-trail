data "aws_route53_zone" "this" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "api_certificate_validation" {
  for_each = {
    for option in aws_acm_certificate.api.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "apex_cloudfront_a" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.apex_domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_cloudfront_aaaa" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.apex_domain_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
