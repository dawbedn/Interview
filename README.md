
# Introduction

Solutions to the tasks were completed using React app from repository: (https://github.com/Rahul-Pandey7/react-image-compressor).

To test given solutions, please clone the repository and copy given files to the directory.

## Task 1

### Development environment
This task started with creating two Dockerfiles for Nginx and React applications. 

To begin with nginx, I specified configuration inside `default.conf` file. It enables access/error logging and enables proxy for the React app. Dockerfile was based on official Nginx image and was created to use specified configuration from `default.conf` file instead of the default one.

Dockerfile for React app builds image, that includes dependencies specified inside `package*.json` files. It sets working directory in the container and also builds and starts the application. It exposes port 3000 to communicate with nginx.

To build images we need host with installed Docker, and issue commands inside folder that contains Dockerfile:
```
  docker build -t tag .
```
Example that builds the image, and pushes to remote Docker Hub repository:
```
  dockerbuild -t dawbed/react-cub .
```

Created images were deployed using manifest file `docker-compose.yml`. Docker Compose creates network for containers, so it is not required to specify it explicitly. It exposes nginx with port 8080, which proxies connection to the React app that is only accessible by connecting via nginx on port 8080. Locally it can be reached by connecting to:
```
  https://localhost:8080
```


## Task 2

### Kubernetes Resources

Minikube will be used to run Kubernetes cluster locally.

Docker images from previous task can be re-used in Kubernetes. Starting with two images, we need to create two deployments and services. Instead of using `docker-compose.yml` we create two Kubernetes manifests `react.yaml` and `nginx.yaml`.

Both manifests creates deployment that includes one replica and exposes the deployment with created service.

React app will only communicate inside the cluster hence it uses ClusterIP. For Nginx we need NodePort or LoadBalancer service, that allows to communication outside the cluster.

Commands used to deploy resources:
```
  kubectl apply -f react.yaml
  kubectl apply -f nginx.yaml
```
Service will be now in pending state, to expose it outside Minikube cluster, we should issue command:

```
  minikube tunnel
```

## Task 3

### Deployment to production

Required AWS resources were created using Terraform. The HCL code is stored inside repository in file `main.tf`.

Credentials file with access key and token for AWS was created to protect sensitive data from storing in clear-text form inside main Terraform code. Path for the credentials file:

`$HOME/.aws/credentials`

Terraform scripts creates ECR instance called **app_repo**. Next it utilizes open-source module to create CodeBuild instance and it creates variables that will be used to build Docker images, such as **aws_account_id, image_repo_name, image_tag**, etc.

CodeBuild uses `buildspec.yml` file which defines three phases: **pre_build, build and post_build.** It was created to build Docker Image and push it to previously created ECR instance. In addition to run the process we need S3 input bucket, AWS CodeCommit, GitHub or Bitbucket repository. We also have to use IAM roles to allow the execution, for example roles such as: *AmazonEC2ContainerRegistryFullAccess* or *AmazonEC2ContainerRegistryPowerUser.*

To run the Terraform script it is required to install Terraform. (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

Next move to directory that contains **main.tf** file and issue commands:

```bash
  terraform init

  terraform apply -auto-approve
```