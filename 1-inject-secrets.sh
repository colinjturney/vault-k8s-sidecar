#!/bin/bash

# Inject secrets in the pod using Vault Agent Injector Service

# The deployment is running the pod with the internal-app Kubernetes service account in the default namespace. The Vault
# Agent Injector only modifies a deployment if it contains a specific set of annotations. An existing deployment may have
# its definition patched to include the necessary annotations.

kubectl config set-context --current --namespace default

kubectl patch deployment orgchart --patch "$(cat vault-agent-sidecar/patch-inject-secrets.yml)"

kubectl get pods

sleep 15

kubectl logs \
    $(kubectl get pod -l app=orgchart -o jsonpath="{.items[0].metadata.name}") \
    --container vault-agent

sleep 10

kubectl exec \
    $(kubectl get pod -l app=orgchart -o jsonpath="{.items[0].metadata.name}") \
    --container orgchart -- cat /vault/secrets/database-config.txt
