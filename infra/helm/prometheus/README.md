All was tested on helm 2.12.1

# Prometheus-operator

https://github.com/helm/charts/tree/master/stable/prometheus-operator

## Install

```
helm install prometheus-stack --namespace monitoring --values=values.yaml kube-prometheus-stack/
```

## Upgrade

```
helm upgrade prometheus-stack --namespace monitoring --values=values.yaml kube-prometheus-stack/
```
