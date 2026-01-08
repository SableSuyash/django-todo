# 🚀 Django CI/CD Deployment on AWS using Docker, GitHub Actions & Terraform

This project demonstrates a fully automated CI/CD pipeline to deploy a Django web application on AWS EC2 using Docker containerization, Terraform infrastructure provisioning, and GitHub Actions automation. Every git push to the `main` branch triggers automatic deployment to a stable Elastic IP endpoint.

## 🎯 Project Objectives

- ✅ Containerize Django application using Docker
- ✅ Provision AWS EC2 infrastructure using Terraform
- ✅ Use Elastic IP for stable public endpoint
- ✅ Automate deployment with GitHub Actions CI/CD
- ✅ Zero manual server intervention after setup
- ✅ Automatic redeployment on every GitHub push

## 🛠️ Tech Stack

| Category | Tools |
|----------|-------|
| **Programming** | Python, Django |
| **Containerization** | Docker |
| **CI/CD** | GitHub Actions |
| **Cloud** | AWS EC2, Elastic IP |
| **IaC** | Terraform |
| **OS** | Ubuntu 22.04 |
| **Version Control** | Git, GitHub |

## 🏗️ Project Architecture

```
Developer
   |
   | git push
   v
GitHub Repository
   |
   | GitHub Actions (CI/CD)
   v
AWS EC2 (Elastic IP)
   |
   | Docker Container
   v
Django Web Application
```

## 📂 Project Structure

```
django-todo/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── Dockerfile
├── docker-compose.yml
├── manage.py
├── requirements.txt
├── todoApp/
├── todos/
├── db.sqlite3
├── .dockerignore
├── .gitignore
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md
```

## 🐳 Docker Setup

### Dockerfile Highlights
```dockerfile
FROM python:3.10-slim
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN python manage.py migrate
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

## ☁️ Infrastructure Setup (Terraform)

Terraform provisions:
- EC2 instance (Ubuntu 22.04)
- Existing key pair attachment
- Security group configuration
- User data for Docker installation

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

**Note**: Elastic IP must be manually associated post-creation to avoid IP changes.

## 🔄 CI/CD Pipeline (GitHub Actions)

**Trigger**: Every push to `main` branch

**Workflow**: `.github/workflows/deploy.yml`

### Pipeline Steps
1. Checkout latest code
2. SSH into EC2 (using GitHub Secrets)
3. Git pull latest changes
4. Stop & remove old container
5. Build new Docker image
6. Run updated container with restart policy

```yaml
name: Deploy Django App to EC2
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to EC2
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USER }}
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            cd django-todo
            git pull origin main
            docker stop django-container || true
            docker rm django-container || true
            docker build -t django-app .
            docker run -d --restart unless-stopped -p 8000:8000 --name django-container django-app
```

## 🔐 GitHub Secrets Required

| Secret Name | Value |
|-------------|-------|
| `EC2_HOST` | Elastic IP of EC2 |
| `EC2_USER` | `ubuntu` |
| `EC2_SSH_KEY` | Private SSH key (.pem content) |

## 🚀 Quick Start

1. **Clone repository**
   ```bash
   git clone https://github.com/yourusername/django-todo.git
   cd django-todo
   ```

2. **Setup Terraform infrastructure**
   ```bash
   cd terraform
   terraform init && terraform apply
   ```

3. **Configure GitHub Secrets** (Settings → Secrets → Actions)

4. **Push to main branch** → Deployment auto-starts!

## ✅ Key Learnings

- **Docker**: Environment consistency across dev/staging/prod
- **Terraform**: Infrastructure as Code (repeatable & versioned)
- **GitHub Actions**: Zero-cost CI/CD automation
- **Elastic IP**: Solves EC2 public IP change problem
- **Container restart policies**: Ensures high availability

## 🔮 Future Improvements

- [ ] Gunicorn + Nginx for production-grade serving
- [ ] Automated testing stage in CI pipeline
- [ ] Docker image push to ECR/Docker Hub
- [ ] HTTPS with Application Load Balancer
- [ ] Route 53 custom domain
- [ ] CloudWatch monitoring & alerts
- [ ] Database migration to RDS

## 👨‍💻 Author

**Suyash Sopan Sable**  
Aspiring Cloud/DevOps Engineer  
[LinkedIn](https://linkedin.com/in/suyashsable) | [Portfolio](https://suyashsable.dev)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**⭐ Star this repository if you found it helpful!**
