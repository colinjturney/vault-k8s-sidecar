#!/bin/sh

# Here is an example of a pod bound to a different namespace attempting to access a secret in Vault. It fails.

kubectl config set-context --current --namespace default

kubectl create namespace offsite

kubectl config set-context --current --namespace offsite

# Create internal-app service account within the offsite namespace to test it won't work.

kubectl apply -f vault-agent-sidecar/service-account-internal-app.yml

# Create app deployment called issues that attempts to deploy issues app on internal-app SA in the offsite NS.

kubectl apply -f vault-agent-sidecar/deployment-issues.yml

sleep 15

kubectl get pods

kubectl logs \
    $(kubectl get pod -l app=issues -o jsonpath="{.items[0].metadata.name}") \
    --container vault-agent-init
