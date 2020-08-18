#!/bin/sh

# Here is an example of a pod bound to a different service account attempting to access a secret in Vault. It fails.

kubectl config set-context --current --namespace default

kubectl apply -f vault-agent-sidecar/deployment-website.yml

sleep 10

kubectl get pods

kubectl logs \
    $(kubectl get pod -l app=website -o jsonpath="{.items[0].metadata.name}") \
    --container vault-agent-init
