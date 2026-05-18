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

source "docker" "ubuntu-latest" {
    image = var.ubuntu_latest_image
    commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal",
    "source.docker.ubuntu-latest",
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

  post-processor "manifest" {
    output = var.manifest_output
    strip_path = true
    custom_data = {
      my_custom_data = var.custom_data["my_custom_data"]
    }
  }

}

