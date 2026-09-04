# Wie in dev, standardmaessig lokal, fuer echten Betrieb ein Remote Backend nutzen.
#
# terraform {
#   backend "s3" {
#     bucket         = "mein-terraform-state-bucket"
#     key            = "lernprojekt/prod/terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
