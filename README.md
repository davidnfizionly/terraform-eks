#  Terraform EKS Demo App

##  Project Overview
This project demonstrates a **full end-to-end deployment of a Kubernetes application on Amazon EKS** using **Terraform** for infrastructure and **GitHub Actions** for CI/CD.  

The application stack:  
- **Frontend**: React app served with NGINX  
- **Backend**: Node.js Express API (`/api`)  
- **Ingress**: AWS ALB routing `/` → frontend and `/api` → backend  

---

##  Architecture
- **Terraform** provisions:  
  - VPC with public/private subnets, NAT Gateway, route tables  
  - Amazon EKS Cluster + Managed Node Groups  
  - IAM Roles and OIDC integration for GitHub Actions  
- **Kubernetes Add-ons**: ALB Ingress Controller, Metrics Server  
- **CI/CD**: GitHub Actions builds Docker images → pushes to Amazon ECR → deploys to EKS  
- **Monitoring**: CloudWatch for logs and metrics  

---

## 🔐 IAM Role & Permissions

For GitHub Actions to deploy into EKS, we created an IAM role **`AppDeployRole`** with trust policy for GitHub OIDC.  

### Trust Policy (JSON)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<account_id>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:davidnfizionly/terraform-eks:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

### Permissions Policy (JSON)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:UpdateKubeconfig",
        "eks:AccessKubernetesApi",
        "eks:ListUpdates",
        "eks:DescribeUpdate",
        "iam:PassRole",
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    }
  ]
}
```

This role was then added to the **`aws-auth ConfigMap`** to allow GitHub Actions to deploy into EKS with `system:masters` privileges.

---

##  Step-by-Step Setup

### Step 1: Provision Infrastructure with Terraform
1. Create Terraform configuration (`main.tf`, `variables.tf`, `outputs.tf`)  
2. Configure remote state in **S3 + DynamoDB**  
3. Deploy VPC, Subnets, NAT Gateway, Route Tables  
4. Deploy **Amazon EKS Cluster** + Node Groups  

Commands:
```sh
cd terraform-eks/live
terraform init
terraform apply
```

---

### Step 2: Configure Kubernetes Add-ons
1. Deploy **AWS ALB Ingress Controller** via Helm  
2. Deploy **Metrics Server** for autoscaling  
3. (Optional) Deploy Prometheus + Grafana  

Commands:
```sh
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller   -n kube-system   --set clusterName=terraform-eks-demo-eks
```

---

### Step 3: Build & Push Docker Images
GitHub Actions (`.github/workflows/app.yml`) builds automatically.  

Manual build (if needed):  
```sh
# Frontend
cd eks-demo-ui/frontend
docker build -t eks-demo-frontend .
docker tag eks-demo-frontend:latest <account_id>.dkr.ecr.us-east-1.amazonaws.com/eks-demo-frontend:latest
docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/eks-demo-frontend:latest

# Backend
cd ../backend
docker build -t eks-demo-backend .
docker tag eks-demo-backend:latest <account_id>.dkr.ecr.us-east-1.amazonaws.com/eks-demo-backend:latest
docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/eks-demo-backend:latest
```

---

### Step 4: Deploy App to EKS
1. Apply Kubernetes manifests:  
   - `frontend-deployment.yaml`  
   - `backend-deployment.yaml`  
   - `frontend-service.yaml`  
   - `backend-service.yaml`  
   - `ingress.yaml`  

Commands:
```sh
kubectl apply -f eks-demo-ui/k8s/frontend-deployment.yaml
kubectl apply -f eks-demo-ui/k8s/backend-deployment.yaml
kubectl apply -f eks-demo-ui/k8s/frontend-service.yaml
kubectl apply -f eks-demo-ui/k8s/backend-service.yaml
kubectl apply -f eks-demo-ui/k8s/ingress.yaml
```

2. Verify:
```sh
kubectl get pods -o wide
kubectl get svc
kubectl get ingress
```

---

### Step 5: Access Application
- **Frontend:**  
  `http://<ALB_DNS>`  

- **Backend API:**  
  `http://<ALB_DNS>/api`  
  

---

##  Future Improvements
- Add HTTPS (SSL termination at ALB)  
- Add HPA for pod autoscaling  
- Add Prometheus + Grafana dashboards  
- Multi-environment setup (dev, staging, prod)  

---

##  Skills Demonstrated
- AWS Infrastructure with Terraform  
- Kubernetes Deployment on EKS  
- GitHub Actions CI/CD with OIDC IAM role  
- Docker & Amazon ECR  
- Observability with CloudWatch  
- Secure IAM permissions management  
