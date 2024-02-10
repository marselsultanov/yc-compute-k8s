# yc-compute-k8s
Prerequisites:
1. VPC network (default) and subnet (default-ru-central1-a with 10.0.0.0/24)
2. VM with public ip (ssh-proxy)
3. Service account (terraform)

Connect to VMs:
1. ssh -J ssh-proxy almalinux@k8s-cp
2. ssh -J ssh-proxy almalinux@k8s-node-1
3. ssh -J ssh-proxy almalinux@k8s-node-2
4. ssh -J ssh-proxy almalinux@k8s-node-3