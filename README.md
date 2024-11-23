# Strimzi Poc 

## install kind 
- [install doc](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

## Create a kind cluster

```bash
kind create cluster --config ./kind.yaml
```

## Change the context of you kubeconfig

```bash
kubectl cluster-info --context kind-kind
```

## Apply the cluster without zookeper
- [YAML](./cluster/kraft/kafka-cluster.yaml)

 ```bash
    kubectl apply -f cluster/kraft/kafka-cluster.yaml 
```

## Apply the cluster with zookeper 
- [YAML](./cluster/with-zookeper/kafka-persistent.yaml)

```bash
kubectl apply -f cluster/with-zookeper/kafka-persintent.yaml
```

## Create a topic

- [YAML](./topics/topics.yaml)

```bash
kubectl apply -f topics/topics.yaml
```
