# Standardmaessig wird der State lokal in dieser Umgebung gespeichert.
# Fuer echte Teams gehoert hier ein Remote Backend hin, damit sich
# der State nicht ueberschreibt, wenn mehrere Personen daran arbeiten.
# Beispiel fuer ein S3 Backend mit Locking als Kommentar.
#
# terraform {
#   backend "s3" {
#     bucket         = "mein-terraform-state-bucket"
#     key            = "lernprojekt/dev/terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
