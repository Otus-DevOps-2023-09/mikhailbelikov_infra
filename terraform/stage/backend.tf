terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "mm-belikov"
    region   = "ru-central1"
    key      = "stage.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
