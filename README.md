# Vault-K8s-Sidecar
This demo shows how Vault Server can be deployed on Kubernetes using the hashicorp/vault helm chart and how the Vault Agent Injector service can leverage a Kubernetes mutating admission webhook to intercept pods that define specific annotations and inject a Vault Agent container to manage these secrets.


## Requirements

The demo was developed and tested with the following setup:
- OSX Catalina (10.15.6)
- minikube version: v1.12.3
- docker version: Client: Docker Engine - Community / Version: 19.03.8
- helm version: v3.3.0
- kubectl client version: v1.18.8

## Prerequisites
- Minikube installed
- Docker desktop installed
- helm installed
- kubectl installed

## How to run the demo

Run the scripts in numerical order. To kill Vault at any time, just run `./99-kill-vault`

You'll need to kill the minikube cluster separately with a `minikube delete`

## Todo
- Improve this README and code comments.

## Based On
- Examples used from this HashiCorp Learn article - [Vault Kubernetes Sidecar](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar)

## FAQs

1. The documentation mentions the ability to create initContainers and sidecarContainers. How do I configure these?
  - To configure only an initContainer, specify this option in your annotations: [vault.hashicorp.com/agent-prepopulate-only](https://www.vaultproject.io/docs/platform/k8s/injector/annotations#vault-hashicorp-com-agent-pre-populate-only)
  - To see the full list of annotations [see here](https://www.vaultproject.io/docs/platform/k8s/injector/annotations)

Other FAQs will be added as they are asked.
