# Infrastructure Terraform Project

Ce projet contient des configurations Terraform pour déployer et gérer une infrastructure cloud et Kubernetes. Il est divisé en deux parties principales : l'initialisation du backend Terraform et la gestion de l'infrastructure Kubernetes.

## Structure du projet

- `init_backend/` : Configuration pour initialiser le backend Terraform.
- `infrastructure/` : Configuration pour déployer des ressources Kubernetes et Helm.

## Prérequis

- **Terraform** version >= 1.3.0
- Un compte Scaleway avec les clés d'accès configurées
- Accès à un cluster Kubernetes et un fichier kubeconfig valide

## Initialisation du backend Terraform

Le backend Terraform est configuré pour utiliser un bucket Scaleway pour stocker l'état Terraform.

### Fichiers principaux

- `init_backend/main.tf` : Définit le backend local et crée un bucket Scaleway pour l'état Terraform.
- `init_backend/variables.tf` : Définit les variables nécessaires (clés d'accès, ID de projet).
- `init_backend/env.tfvars` : Contient les valeurs des variables sensibles (ne pas partager publiquement).

### Commandes

1. Initialiser le backend localement :
   ```bash
   terraform init
   ```
2. Appliquer la configuration pour créer le bucket :
   ```bash
   terraform apply -var-file=env.tfvars
   ```

## Déploiement de l'infrastructure Kubernetes

Cette partie configure des ressources Kubernetes et des charts Helm pour des composants comme NGINX Ingress et Cert Manager.

### Fichiers principaux

- `infrastructure/main.tf` : Définit les providers Kubernetes et Helm, ainsi que les ressources principales.
- `infrastructure/values/ingress-nginx.yaml` : Configuration pour le contrôleur NGINX Ingress.
- `infrastructure/values/cert-manager.yaml` : Configuration pour Cert Manager.

### Ressources déployées

- **NGINX Ingress Controller** : Gère les ingress HTTP/HTTPS.
- **Cert Manager** : Automatise la gestion des certificats SSL.
- **ClusterIssuer** : Configure un émetteur Let's Encrypt pour les certificats.

### Commandes

1. Initialiser Terraform :
   ```bash
   terraform init
   ```
2. Appliquer la configuration :
   ```bash
   terraform apply
   ```

## Notes importantes

- Les clés d'accès Scaleway dans `env.tfvars` sont sensibles. Assurez-vous de ne pas les exposer.
- Le backend Terraform est configuré pour utiliser un bucket Scaleway avec un endpoint S3.

## Auteur

Loïc Vanden Bossche
