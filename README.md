# yc-compute-k8s
Prerequisites:
1. VPC network and subnet
2. NAT for VPC network
3. VM with public ip (for use as ssh-proxy)
4. Service account (for terraform)

Don't forget to replace with yours:
1. cloud_id and folder_id
3. service_account_key_file and service_account_id
5. subnet_ids
6. ip_address (also in kubeadm-config.yaml)
7. ssh-keys

Connect to VMs:
1. ssh -J ssh-proxy almalinux@k8s-control-1
2. ssh -J ssh-proxy almalinux@k8s-worker-1
3. ssh -J ssh-proxy almalinux@k8s-worker-2
4. ssh -J ssh-proxy almalinux@k8s-worker-3