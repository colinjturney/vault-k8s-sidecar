#!/bin/bash

# Apply a template to the injected secrets

# The structure of the injected secrets may need to be structured in a way for an application to use. Before writing the
# secrets to the file system a template can structure the data. To apply this template a new set of annotations need to be
# applied.

kubectl config set-context --current --namespace default

kubectl patch deployment orgchart --patch "$(cat vault-agent-sidecar/patch-inject-secrets-as-template.yml)"

sleep 15

kubectl get pods

kubectl exec \
    $(kubectl get pod -l app=orgchart -o jsonpath="{.items[0].metadata.name}") \
    -c orgchart -- cat /vault/secrets/database-config.txt
