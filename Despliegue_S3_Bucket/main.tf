resource "aws_s3_bucket" "storage" {
  bucket = "${var.client_name}-${var.project_name}-backend-tfstate"

  tags = {
    Name = "My Bucket"
    Environment = "${var.client_name}-${var.project_name}-dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.storage.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.storage.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# ya no es obligatorio pero sí recomendable una tabla de dynamodb para disponer de un backend remoto en s3

resource "aws_dynamodb_table" "terraform_locks" {
  name = "${var.project_name}-${var.client_name}-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}