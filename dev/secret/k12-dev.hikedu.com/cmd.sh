#!/bin/bash
kubectl create secret generic ca.crt --from-file=./ca.crt --namespace=micro
kubectl create secret generic ca.key --from-file=./ca.key --namespace=micro
