# Go Web Application – End-to-End CI/CD on Kubernetes (GKE) with Helm, ArgoCD & GitHub Actions

This project demonstrates a **Complete DevOps CI/CD pipeline** for deploying a simple **Go web application** (serving static HTML files) on a **GKE Kubernetes cluster** using modern tools like **Docker, Helm, GitHub Actions, and ArgoCD**.

This is a simple website written in Golang. It uses the `net/http` package to serve HTTP requests.

### Tools and Technologies used
- **Go**: Web application backend (serves static HTML files)
- **Docker**: Containerization of the Go web app
- **Kubernetes (GKE)**: Orchestration platform
- **Helm**:	Packaging and managing Kubernetes manifests
- **NGINX Ingress Controller**:	Manages inbound traffic to services
- **GitHub Actions**: Continuous Integration (build, test, lint, dockerize, push)
- **ArgoCD**: Continuous Deployment (GitOps)
- **Google Cloud Platform (GCP)**: Cloud provider hosting the cluster

## Project Flow

### 1. Local Setup and Running the server

To run the server, execute the following command:

```bash
go run main.go
```

The server will start on port 8080. You can access it by navigating to `http://localhost:8080/home` in your web browser.

### 2. Containerisation

Build and test docker image locally:

```bash
# Build the image
docker build -t go-web-app:v1 .

# Run the container locally
docker run -d -p 8080:8080 go-web-app:v1
```

### 3. Kubernetes cluster setup

Created the manifests - deployment.yaml, service.yaml and ingress.yaml in `k8s/` directory

Applied the NGINX Ingress controller using the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml
```

### 4. Helm Packaging

Create Helm chart

```bash
helm create go-web-app-chart
```

Create necessary templates and update `go-web-app-chart/values.yaml` file

### 5. GitHub Actions CI Pipeline

Create `.github/workflows/ci.yaml` and the add the necessary jobs and actions.

### 6. ArgoCD Setup and Configuration

Install ArgoCD

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Get the ArgoCD password using the following commands:
```bash
# Copy the password
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml

# Decode the base64 password
echo <BASE64_PASSWORD> | base64 --decode
```

### 7. Testing the Complete Pipeline

Test the complete pipeline by pushing some changes to `main` branch.

Check the `actions` in Github, and verify the latest tag in `Docker`.

Verify the working of `ArgoCD` in the UI and the check the image tag in `k8s Deployment`.

## Cleanup

### 1. Uninstall ArgoCD

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd
```

### 2. Uninstall Ingress Controller

```bash
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml
```

### 3. Uninstall the go-web-app application

```bash
kubectl delete deploy go-web-app
kubectl delete svc go-web-app
kubectl delete ingress go-web-app
```