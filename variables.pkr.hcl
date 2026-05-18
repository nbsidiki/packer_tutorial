variable "docker_image" {
  type    = string
  default = "ubuntu:jammy"
}

variable "ubuntu_focal_image" {
  type    = string
  default = "ubuntu:focal"
}

variable "example_txt_content" {
  type    = string
  default = "FOO is $FOO"
}

variable "ubuntu_jammy_tags" {
  type    = list(string)
  default = ["ubuntu-jammy", "packer-rocks"]
}

variable "ubuntu_focal_tags" {
  type    = list(string)
  default = ["ubuntu-focal", "packer-rocks"]
}
