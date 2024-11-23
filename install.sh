#!/bin/bash

# check if docker is running
systemctl status docker | grep "active (running)"
if [ $? -ne 0 ]; then
    echo "Docker is not running"
    systemctl start docker
fi

# check if cluster is running

if [ $(kubectl get nodes | wc -l) -eq 1 ]; then
    echo "Cluster is not running"]
    kind create cluster --config kind-config.yaml
    kubectl cluster-info --context kind-kind
    if [ $? -ne 0 ]; then
        echo "Failed to create cluster"
        exit 1
    fi
fi

# Install helm chart
helm install my-strimzi-cluster-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --values ./helm-operator/values.yaml
if [ $? -ne 0 ]; then
    echo "Failed to install helm chart"
    exit 1
fi

# install kafka cluster with zookeeper
#kubectl apply -f ./cluster/kafka-persistent.yaml

# install kafka cluster without zookeeper
kubectl apply -f ./cluster/kraft/kafka-cluster.yaml