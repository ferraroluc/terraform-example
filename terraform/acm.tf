resource "tls_private_key" "example-tls-private" {
  algorithm = "RSA"
}
resource "tls_self_signed_cert" "example-tls-signed" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.example-tls-private.private_key_pem

  subject {
    common_name  = "example.com.ar"
    organization = "Example"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
resource "aws_acm_certificate" "example-cert" {
  private_key      = tls_private_key.example-tls-private.private_key_pem
  certificate_body = tls_self_signed_cert.example-tls-signed.cert_pem
}