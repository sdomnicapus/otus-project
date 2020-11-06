All was tested on helm 2.12.1

# Non-values files

- [logstash_es_template.json](./logstash_es_template.json) - template for ES to NOT make replicas and cluster would normaly be in GREEN state

# ElasticSearch

Previously were using [stable chart](https://github.com/helm/charts/tree/master/stable/elasticsearch), but in [72204](http://support.otus.com/helpdesk/tickets/72204) switched to self-written helm chart with one node ES to use memory of clients and masters to ES

After installation [logstash_es_template.json](./logstash_es_template.json) should be set up in cluster

## Install

```
helm install elasticsearch --namespace monitoring --values=values-elasticsearch-single.yaml elasticsearch-single/
```

## Upgrade

```
helm upgrade elasticsearch --values=values-elasticsearch-single.yaml --namespace monitoring --wait elasticsearch-single/
```

# Kibana

https://github.com/helm/charts/tree/master/stable/kibana

## Install

```
helm install kibana --namespace monitoring --values=values-kibana.yaml kibana/
```

## Upgrade

```
helm upgrade kibana --values=values-kibana.yaml --namespace monitoring --wait kibana/
```

# Fluentd

https://github.com/helm/charts/tree/master/stable/kibana

## Install

```
helm install fluentbit --namespace monitoring --values=values-fluentbit-ENV.yaml fluent-bit/
```

## Upgrade

```
helm upgrade fluentbit --wait --namespace monitoring --values=values-fluentbit-ENV.yaml fluent-bit/
```

# ElasticSearch exporter

https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter

After installation [elasticsearch-exporter-servicemonitor.yaml](./elasticsearch-exporter-servicemonitor.yaml) should be applied so Prometheus would start to scrape it

## Install

```
helm install elasticsearch-exporter --namespace monitoring elasticsearch-exporter --values=values-elasticsearch-exporter.yaml elasticsearch-exporter/
```

## Upgrade

```
helm upgrade elasticsearch-exporter --wait --namespace monitoring elasticsearch-exporter --values=values-elasticsearch-exporter.yaml elasticsearch-exporter/
```

# Increase `data` Persistent Storage Claim size

1. Make sure that connected Persistent Volume has `persistentVolumeReclaimPolicy: Retain`
2. Change Persistent Volume size via edit
3. Via Google Cloud increase connected disk (disk name may be found in Persistent Volume status)
4. Set Stateful Set replicas of data to `0`
5. Delete Persistent Volume Claim of data (probably `monitoring/data-elasticsearch-data-0`) - Persistent Volume will be in `Released` state
6. Edit Persistent Volume - delete `claimRef` block
7. Change Persistent Volume Claim definition to have proper size (file `pvc-elasticsearch.yaml`)
8. Apply new Persistent Volume Claim
9. Make sure that Persistent Volume is in `Bound` state and Persistent Volume Clain is in `Bound` state with defined `Capacity`
10. Set Stateful Set replicas of data to `1`
11. Get node where pods is launched via `kubectl get pods -n monitoring -o wide`
12. Get into node via SSH (`gcloud compute ssh NODE`)
13. Resize disk used by system (`mount | grep PV_NAME; resize2fs PV_DISK`)
14. Check disk size inside container (`df -h | grep /usr/share/elasticsearch/data`)

