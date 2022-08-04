terraform {
  backend "s3" {
  endpoint = "http://minio.minio"


  region = "eu-west-1"
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_region_validation = true
  force_path_style = true
  }
}