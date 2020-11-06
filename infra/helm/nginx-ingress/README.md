All was tested on helm 2.12.1

# Nginx ingress controller

https://github.com/helm/charts/tree/master/stable/nginx-ingress

## Install

```
#External:

helm install nginx-ingress --namespace nginx-ingress --values=values-external.yaml nginx-ingress/

```

## Upgrade

```
#External:

helm upgrade nginx-ingress --namespace nginx-ingress --values=values-external.yaml --wait nginx-ingress//

```
