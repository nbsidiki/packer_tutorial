packer {
  required_plugins {
    docker2 = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker2" "ci-cd" {
  image  = "node:18-slim"
  commit = true
  changes = [
    "WORKDIR /app",
    "ENV PASSPHRASE=test",
    "EXPOSE 3000",
    "CMD [\"npm\", \"start\"]",
  ]
}

build {
  name = "ci-cd-image"
  sources = ["source.docker2.ci-cd"]

  provisioner "file" {
    source      = "ci-cd-main/"
    destination = "/app"
  }

  provisioner "shell" {
    inline = [
      "cd /app",
      "export PASSPHRASE=${var.app_passphrase}",
      "npm install --production",
    ]
  }

  post-processor "docker-tag" {
    repository = "ci-cd-image"
    tags       = ["latest"]
  }
}
