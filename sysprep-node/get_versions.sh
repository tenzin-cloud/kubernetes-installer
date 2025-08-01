#!/bin/bash

KUBERNETES_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.tag_name | sub("^v"; "")')
CONTAINERD_VERSION=$(curl -s https://api.github.com/repos/containerd/containerd/releases/latest | jq -r '.tag_name | sub("^v"; "")')
RUNC_VERSION=$(curl -s https://api.github.com/repos/opencontainers/runc/releases/latest | jq -r '.tag_name | sub("^v"; "")')
CNI_PLUGINS_VERSION=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | jq -r '.tag_name | sub("^v"; "")')
CRICTL_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/cri-tools/releases/latest | jq -r '.tag_name | sub("^v"; "")')
CILIUM_CLI_VERSION=$(curl -s https://api.github.com/repos/cilium/cilium-cli/releases/latest | jq -r '.tag_name | sub("^v"; "")')

cat <<eof
kubernetes_version: $KUBERNETES_VERSION
containerd_version: $CONTAINERD_VERSION
runc_version: $RUNC_VERSION
cni_plugins_version: $CNI_PLUGINS_VERSION
crictl_version: $CRICTL_VERSION
cilium_cli_version: $CILIUM_CLI_VERSION
eof
