# Django Greeting App on EKS with RDS

This project demonstrates deploying a containerized Django web application to AWS using the following stack:

- **Django 5.2.2** – Web framework
- **MySQL on Amazon RDS** – Managed database
- **Amazon EKS** – Kubernetes cluster
- **Helm** – Package manager for Kubernetes
- **AWS Secrets via Kubernetes** – Secure environment configuration
- **Docker & ECR** – Image build and registry
- **Terraform** – (https://github.com/JustinRuiz321/devops-django-tf)

---

## 📁 Project Structure

```
.
├── db.sqlite3
├── Dockerfile
├── entrypoint.sh
├── greetings/             # Django app
├── manage.py
├── mysite/                # Django project
├── mysite-app/            # Helm chart
│   ├── Chart.yaml
│   ├── templates/
│   └── values.yaml
└── requirements.txt
```

---

## ⚙️ Deployment Architecture

```text
User → AWS ALB → EKS Service → Pod (Django app) ↔ Amazon RDS (MySQL)
                                 ↑
                          Kubernetes Secrets
```

---

## 🚀 Deployment Steps

### 1. Create Secrets in Kubernetes

```sh
kubectl create secret generic mysite-secret \
  --namespace mysite \
  --from-literal=DB_HOST=<RDS_ENDPOINT> \
  --from-literal=DB_PORT=3306 \
  --from-literal=DB_NAME=mysite \
  --from-literal=DB_USER=jruiz \
  --from-literal=DB_PASSWORD=****** \
  --from-literal=DJANGO_SECRET_KEY='your-django-secret-key'
```

---

### 2. Build and Push Docker Image to ECR

```sh
export VERSION=v1.0.4

docker build -t mysite-app:$VERSION .
docker tag mysite-app:$VERSION <account-id>.dkr.ecr.us-east-1.amazonaws.com/mysite-app:$VERSION
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/mysite-app:$VERSION
```

---

### 3. Helm Deployment

Update `mysite-app/values.yaml` to reference the correct image version and ECR path.

```sh
helm upgrade --install mysite-app ./mysite-app -n mysite
```

---

## 🔒 Security & Best Practices

- No hardcoded credentials in `settings.py`. All sensitive data is read from environment variables sourced from Kubernetes secrets.
- Database and Django secret key are managed securely via `kubectl create secret`.
- Pod resource requests/limits defined in `deployment.yaml` to improve scheduling and prevent overutilization.

---

## ⚠️ Warnings & Considerations
 
- **Development Server**: The app currently uses Django’s dev server.

---

## 📎 Useful Commands

**Check logs**
```sh
kubectl logs -l app=mysite-app -n mysite --tail=100
```

**Port-forward locally**
```sh
kubectl port-forward svc/mysite-app -n mysite 8000:8000
```


## ✅ Features Implemented

- Dockerized Django application with custom entrypoint
- Static files served via WhiteNoise
- Secure database credentials using Kubernetes Secrets
- MySQL backend on AWS RDS
- Kubernetes deployment via Helm
- AWS ECR integration for image storage
- Automatic data seeding via Django migrations

---

## 🧪 Testing & Validation

- Verified DB connectivity via RDS
- Confirmed secret injection and environment isolation
- Ran all Django migrations in container startup
- Static files successfully served via `/static/`

# devops-django-app
