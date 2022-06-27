# EKS Demo Flask App

## Table of Contents

- [About](#about)
- [Part 1 - Infrastructure Setup via IaC](#infra)
- [Part 2 - Application Deployment Setup](#app)
- [Part 3 - Test Database Connection](#test)

## About <a name = "about"></a>

This repo contains Terraform modules to launch EKS, RDS, and VPC based AWS resources to host a sample Python application (utilizing Flask as the web app framework), which will authenticate into a MySQL based RDS database instance. 
The RDS DB will be hosted in a private subnet group to enhance network security. We will be using ECR to host our containerized application's image.

The Directory Structure Is As Follows:

- app folder - contains app.py (application code, which contains code to connect to the database), Dockerfile for containerization (Python 3.8 Linux base image), and requirements.txt to package the application dependencies within the container (including NLTK & Pillow).
- infra folder - contains k8s subfolder which contains our Kubernetes manifest files, contains terraform-live folder which will launch our infra by calling the custom Terraform modules which are stored in the terraform-modules folder.

### Prerequisites

- You will need to be authenticated as an AWS user with sufficient permissions to launch the infrastructure as code via Terraform. Likewise, you will need the aws-cli, Terraform, kubectl, git configured to clone this repository, and Docker-Desktop binaries/apps pre-configured.


##  Part 1 - Infrastructure Setup <a name = "infra"></a>

1) Clone Git Repo - The first step would be to clone this repository into your local directory.
```shell
git clone https://github.com/clazar818/eks-flask-app.git
```

2) Launching VPC - Once the repository is cloned, we will begin to launch the infrastructure via Terraform. The first portion is to launch the network, aka VPC. Use Terraform to launch the VPC and the associated resources. This VPC will host our EKS cluster, once the cluster is launched.
```shell
cd infra/terraform-live/vpc
terraform init
terraform apply --auto-approve
```

3) Launching EKS - Use Terraform to launch the EKS cluster and the associated resources. This EKS cluster will host our containerized application.
For this step, we will need to update the main.tf "module caller file" with the newly created private subnet IDs from the VPC that was previously created, which will host our node group.

Update the values in the below file, and once updated - execute Terraform apply.

infra\terraform-live\eks\main.tf
example:
```
  ### Private Subnets For Our Node Group : ###
  #subnet_id_a = "enter private subnet id from az-a here"
  subnet_id_a = "subnet-01dd48ccbfc86c79a"
  #subnet_id_b = enter private subnet id from az-b here""
  subnet_id_b = "subnet-0fbd92774a5c45480"

```
Launch the cluster, via Terraform:

```shell
cd infra/terraform-live/eks
terraform init
terraform apply --auto-approve
```
4) Launching RDS - Use Terraform to launch the RDS database and the associated resources. The Python application will eventually connect to this RDS database.

Update the vpc_id with the VPC ID from the VPC that we created. 
Update subnet_group_subnet_ids with the subnets that we have defined in our infra\terraform-live\eks\main.tf  (aka the private subnets from our created VPC)
```shell
  ### VPC ID and using private subnets for security best practices ###
  #vpc_id                  = enter the VPC ID from the VPC that you created
 #subnet_group_subnet_ids = ["enter private subnet id from az-a here", "enter private subnet id from az-b here"]
  vpc_id                  = "vpc-0b5c36a37ab89eed0"
  subnet_group_subnet_ids = ["subnet-01dd48ccbfc86c79a", "subnet-0fbd92774a5c45480"]

```
```shell
cd infra/terraform-live/rds
terraform init
terraform apply --auto-approve
```

Retrieve the generated RDS DB password value via the following command, hold onto it for now (in your clipboard, seperate text file, etc..) we will need it for later, for when we launch our k8s db auth secret manifest.
```
terraform output -json
```

The required infrastructure for our containerized application should now be live!

##  Part 2 - Application Deployment Setup <a name = "app"></a>
1) We will need to authenticate into ECR, which contains the ECR repository that was created earlier from part 1 step 3. 

Execute the following to do so (replace ACCT_NUMBER with your AWS account ID):
```shell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ACCT_NUMBER.dkr.ecr.us-east-1.amazonaws.com
```

2) Build the Docker image (you must be in the app directory) and push it to our ECR repository:
```shell
docker build -t flask-app .
docker tag flask-app ACCT_NUMBER.dkr.ecr.us-east-1.amazonaws.com/flask-app:1.0.0
docker push ACCT_NUMBER.dkr.ecr.us-east-1.amazonaws.com/flask-app:1.0.0
```

Replace the ACCT_NUMBER placeholder in the infra\k8s\deployment.yaml file as well, with the AWS account ID:
``` 
image: ACCT_NUMBER.dkr.ecr.us-east-1.amazonaws.com/flask-app:1.0.0
```

3) We will be configuring our credentials, which is being maintained as a secret for security best practices. In the future, another possible solution would be to utilize a secret store manager such as Vault, or AWS SSM.

Using the provided sample secrets.yaml manifest file found in the k8s folder,  enter the RDS DB connection string into the host, and enter the password that we retrieved via terraform output -json

```
apiVersion: v1
kind: Secret
metadata:
  name: newsecret
  namespace: app
type: kubernetes.io/basic-auth
stringData:
  host: ENTER_RDS_DB_HOST_HERE
  username: admin
  password: ENTER_RDS_DB_PASSWORD_HERE
```

Update your EKS Kube context via the following:

```shell
aws eks update-kubeconfig --region us-east-1 --name demo
```


apply the remaining resources via kubectl. We will start with the namespace.

```shell
kubectl apply -f infra\k8s\namespace.yaml
```
Apply the remaining resources:
```shell
kubectl apply -f infra\k8s
```

##  Part 3 - Application Deployment Setup <a name = "test"></a>
At this point your infrastructure and application have been deployed! Navigate to the NLB that we created, copy the host, and navigate to the URL. The Python application will show a connected message indicating a successful connection! :)
