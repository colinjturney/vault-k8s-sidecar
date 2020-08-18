#!/bin/bash

# Install a dev Vault server on minikube

kubectl config set-context --current --namespace default

# Install the Vault helm chart (for simplicity we're just running Vault server itself on Kubernetes here).

helm install vault hashicorp/vault --set "server.dev.enabled=true"

sleep 30

# Set a secret in Vault

kubectl exec -it vault-0 -- /bin/sh -c "vault secrets enable -path=internal kv-v2"

kubectl exec -it vault-0 -- /bin/sh -c "vault kv put internal/database/config username=\"db-readonly-username\" password=\"db-secret-password\""

kubectl exec -it vault-0 -- /bin/sh -c "vault kv get internal/database/config"

# Configure Kubernetes Authentication

kubectl exec -it vault-0 -- /bin/sh -c "vault auth enable kubernetes"

kubectl exec -it vault-0 -- /bin/sh -c "vault write auth/kubernetes/config \
                                        token_reviewer_jwt=\"\$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)\" \
                                        kubernetes_host=\"https://\$KUBERNETES_PORT_443_TCP_ADDR:443\" \
                                        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

kubectl exec -it vault-0 -- /bin/sh -c 'cat <<EOF > ~/policy-internal-app.hcl
path "internal/data/database/config" {
  capabilities = ["read"]
}
EOF'

kubectl exec -it vault-0 -- /bin/sh -c "vault policy write internal-app ~/policy-internal-app.hcl"

kubectl exec -it vault-0 -- /bin/sh -c "vault write auth/kubernetes/role/internal-app \
                                        bound_service_account_names=internal-app \
                                        bound_service_account_namespaces=default \
                                        policies=internal-app \
                                        ttl=24h"

# Define a Kubernetes service account

kubectl apply -f vault-agent-sidecar/service-account-internal-app.yml

kubectl get serviceaccounts

# Deploy orgchart deployment

kubectl apply -f vault-agent-sidecar/deployment-orgchart.yml

kubectl get pods
