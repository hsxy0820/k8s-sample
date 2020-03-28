#!/bin/bash
kubectl create secret generic ca.crt --from-file=./ca.crt --namespace=k12
kubectl create secret generic ca.key --from-file=./ca.key --namespace=k12
