terraform {
  backend "gcs" {
    bucket = "my-avax-nodes-tf-state"
    prefix  = "state"
  }
}
