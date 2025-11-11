# setup-kubernetes
A repository to help setup a Kubernetes cluster.

The `sysprep-node` should be run first, it prepares a clean Ubuntu OS for a Kubernetes installation.
The `cluster-node` then configures and installs a simple Kubernetes cluster.

## example cluster
```
% k get nodes -o wide
NAME    STATUS   ROLES           AGE     VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s-0   Ready    control-plane   5m17s   v1.34.1   192.168.5.118   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-1   Ready    <none>          4m28s   v1.34.1   192.168.5.117   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-2   Ready    <none>          4m28s   v1.34.1   192.168.5.116   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
```
