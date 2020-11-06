module "s3" {
  source = "./s3-module"
  bucket_names = var.bucket_names
}