terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id = "b1ga9e0sds5h8rvo42km"
  folder_id = "b1gujprsli17pb0utubg"
  service_account_key_file = file("~/yandex/authorized_key.json")
}

resource "yandex_compute_instance" "k8s-cp" {
  name = "k8s-cp"
  hostname = "k8s-cp"
  platform_id = "standard-v2"
  zone = "ru-central1-a"

  resources {
    cores  = "2"
    memory = "4"
    core_fraction = "5"
  }

  scheduling_policy {
    preemptible = "true"
  }

  boot_disk {
    initialize_params {
      image_id = "fd877fuskeokm2plco89"
      size = "20"
      type = "network-hdd"
    }
  }

  network_interface {
    subnet_id = "e9b48pmccvr59607kr9n"
  }

  metadata = {
    ssh-keys = "almalinux:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance_group" "k8s-node" {
  name = "k8s-node"
  service_account_id = "ajeo5kgduc596eg0tcfs"

  instance_template {
    name = "k8s-node-{instance.index}"
    hostname = "k8s-node-{instance.index}"
    platform_id = "standard-v2"

    resources {
      cores = "2"
      memory = "4"
      core_fraction = "5"
    }

    scheduling_policy {
      preemptible = "true"
    }

    boot_disk {
      initialize_params {
        image_id = "fd877fuskeokm2plco89"
        size = "20"
        type = "network-hdd"
      }
    }

    network_interface {
      subnet_ids = ["e9b48pmccvr59607kr9n","e2lfpek6fb5m52cem7i4","fl8dhrhm00kfh51l9cln"]
    }

    metadata = {
      ssh-keys = "almalinux:${file("~/.ssh/id_ed25519.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a","ru-central1-b","ru-central1-d"]
  }

  deploy_policy {
    max_unavailable = 0
    max_expansion   = 1
  }
}