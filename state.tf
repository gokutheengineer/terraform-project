terraform {
    backend "s3" {
        bucket = "gokhan-state"
        key = "myproject.state"
        region = "us-east-1"
    }
}