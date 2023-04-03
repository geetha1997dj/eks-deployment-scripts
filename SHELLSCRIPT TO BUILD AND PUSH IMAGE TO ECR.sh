#!/bin/bash

# Set your AWS account ID and ECR repository name
AWS_ACCOUNT_ID=account id
ECR_REPO_NAME=reponame
ECR_IMAGE_VERSION=versiontag
ECR_REGION=region

# Authenticate Docker to your ECR registry
aws ecr get-login-password --region $ECR_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com

# Create the ECR repository (if it doesn't already exist)
aws ecr create-repository --repository-name $ECR_REPO_NAME || true

# Build the Docker image
docker build -t $ECR_REPO_NAME:$ECR_IMAGE_VERSION .

# Tag the Docker image for ECR
docker tag $ECR_REPO_NAME:$ECR_IMAGE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com/$ECR_REPO_NAME:$ECR_IMAGE_VERSION

# Push the Docker image to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com/$ECR_REPO_NAME:$ECR_IMAGE_VERSION

# Remove the Docker image
docker rmi $ECR_REPO_NAME:$ECR_IMAGE_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com/$ECR_REPO_NAME:$ECR_IMAGE_VERSION
