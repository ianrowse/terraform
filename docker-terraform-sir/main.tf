terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pull Ubuntu image
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

# Create Ubuntu container
resource "docker_container" "foo" {
  image = docker_image.ubuntu.image_id
  name  = "foo"

  command = [
    "bash",
    "-c",
    <<-EOT
    apt-get update &&
    apt-get install -y openssh-server sudo &&
    mkdir -p /run/sshd &&
    useradd -m -s /bin/bash shaun &&
    usermod -aG sudo shaun &&
    echo 'shaun:Clownface24' | chpasswd &&
    /usr/sbin/sshd -D
  EOT
  ]

  ports {
    internal = 22
    external = 2222
  }
}
