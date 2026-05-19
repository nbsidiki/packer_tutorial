packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:22.04"
  commit = true
}

source "docker" "alpine" {
  image  = "alpine:3.19"
  commit = true
}

build {
  name = "multi-os"
  sources = [
    "source.docker.ubuntu",
    "source.docker.alpine",
  ]

  provisioner "shell" {
    only = ["docker.ubuntu"]
    inline = [
      "set -eux",
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget",
    ]
  }

  provisioner "shell" {
    only = ["docker.alpine"]
    inline = [
      "set -eux",
      "apk update",
      "apk add --no-cache curl wget",
    ]
  }

  provisioner "shell" {
    inline = [
      "set -eux",
      "mkdir -p /usr/local/bin /usr/local/share",
      "cp /etc/os-release /usr/local/share/system-info.txt",
      "echo \"KERNEL=$(uname -r)\" >> /usr/local/share/system-info.txt",
      "echo \"ARCH=$(uname -m)\" >> /usr/local/share/system-info.txt",
      "echo \"$(curl --version | head -n1)\" >> /usr/local/share/system-info.txt",
      "echo \"$(wget --version | head -n1)\" >> /usr/local/share/system-info.txt",
      "printf '%s\n' '#!/bin/sh' 'cat /usr/local/share/system-info.txt' > /usr/local/bin/show-info.sh",
      "chmod +x /usr/local/bin/show-info.sh",
      "/usr/local/bin/show-info.sh",
    ]
  }

  post-processor "docker-tag" {
    repository = "multi-os-ubuntu"
    tags       = ["latest"]
    only       = ["docker.ubuntu"]
  }

  post-processor "docker-tag" {
    repository = "multi-os-alpine"
    tags       = ["latest"]
    only       = ["docker.alpine"]
  }
}
