packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntu-focal" {
  image  = var.ubuntu_focal_image
  commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal",
  ]

  provisioner "shell" {
    inline = ["echo Running $(cat /etc/os-release | grep VERSION= | sed 's/\"//g' | sed 's/VERSION=//g') Docker image."]
  }

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"${var.example_txt_content}\" > example.txt",
    ]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = var.ubuntu_jammy_tags
    only       = ["docker.ubuntu"]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = var.ubuntu_focal_tags
    only       = ["docker.ubuntu-focal"]
  }

}

