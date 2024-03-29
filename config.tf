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

resource "yandex_compute_instance_group" "k8s-control" {
  name = "k8s-control"
  service_account_id = "ajeo5kgduc596eg0tcfs"

  instance_template {
    name = "k8s-control-{instance.index}"
    hostname = "k8s-control-{instance.index}"
    platform_id = "standard-v2"

    resources {
      cores = "2"
      memory = "4"
      core_fraction = "50"
    }

    scheduling_policy {
      preemptible = "true"
    }

    boot_disk {
      initialize_params {
        image_id = "fd8b0q2bhps6ndpd3856"
        size = "20"
        type = "network-hdd"
      }
    }

    network_interface {
      subnet_ids = ["e9b48pmccvr59607kr9n"]
      ip_address = "172.18.62.155"
    }

    metadata = {
      ssh-keys = "almalinux:${file("~/.ssh/id_ed25519.pub")}"
      user-data = format("%s\n\n%s", templatefile("cloud-init-k8s-prerequisites.yaml", {}), file("cloud-init-k8s-control.yaml"))
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 0
    max_expansion = 1
  }
}

resource "yandex_compute_instance_group" "k8s-worker" {
  name = "k8s-worker"
  service_account_id = "ajeo5kgduc596eg0tcfs"

  instance_template {
    name = "k8s-worker-{instance.index}"
    hostname = "k8s-worker-{instance.index}"
    platform_id = "standard-v2"

    resources {
      cores = "2"
      memory = "8"
      core_fraction = "50"
    }

    scheduling_policy {
      preemptible = "true"
    }

    boot_disk {
      initialize_params {
        image_id = "fd8b0q2bhps6ndpd3856"
        size = "20"
        type = "network-hdd"
      }
    }

    network_interface {
      subnet_ids = ["e9b48pmccvr59607kr9n"]
    }

    metadata = {
      ssh-keys = "almalinux:${file("~/.ssh/id_ed25519.pub")}"
      user-data = format("%s\n\n%s", templatefile("cloud-init-k8s-prerequisites.yaml", {}), file("cloud-init-k8s-worker.yaml"))
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 0
    max_expansion   = 1
  }

  load_balancer {
    target_group_name = "k8s-worker"
  }
}