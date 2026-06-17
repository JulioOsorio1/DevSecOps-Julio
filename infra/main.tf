


# AÑADIR en su lugar — bucket privado con versioning y cifrado:
resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}




resource "aws_db_instance" "app_db" {
  # ... resto de configuración sin cambios ...

  # ✅ Corregido: no accesible desde internet
  publicly_accessible = false

  # ✅ Corregido: almacenamiento cifrado
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn
}




resource "aws_security_group" "web_sg" {
  # ... nombre y descripción sin cambios ...

  # ✅ Corregido: solo HTTPS desde internet
  ingress {
    description = "HTTPS desde internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Sin regla de ingress para el puerto 0-65535
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
