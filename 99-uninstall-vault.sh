#!/bin/bash

kubectl config set-context --current --namespace default

helm uninstall vault

kubectl delete -f vault-agent-sidecar/service-account-internal-app.yml

kubectl delete -f vault-agent-sidecar/deployment-website.yml

kubectl delete -f vault-agent-sidecar/deployment-orgchart.yml

kubectl config set-context --current --namespace offsite

kubectl delete -f vault-agent-sidecar/service-account-internal-app.yml

kubectl delete -f vault-agent-sidecar/deployment-issues.yml
