# Cert manager

https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html

## Install

```
kubectl create ns cert-manager
kubectl apply -f crds.yaml
kubectl apply -f clusterissuer.yaml
helm install cert-manager --values=values.yaml --namespace=kube-system cert-manager/
