After running ansible-playbook

Step 1: Create Cluster with kubeadm

kubeadm init
sudo kubeadm init –pod-network-cidr=10.244.0.0/16
--pod-network-cidr = specify the range of IP addresses for the pod network. We're using the 'flannel' virtual network. If you want to use another pod network such as weave-net or calico, change the range IP address.

Step 2: Manage Cluster as Regular User

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

Step 3: Set Up Pod Network

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

Step 4: Check Status of Cluster

sudo kubectl get nodes
sudo kubectl get pods --all-namespaces

Step 5: Join Worker Node to Cluster

kubeadm join 192.168.40.155:6443 --token n4qdgl.dcmwnoh5f0urm3a8 \
    --discovery-token-ca-cert-hash sha256:d9713c8e7baf0b25f26d542c33a59af68e5b99ab28398479a4d792e16245494a