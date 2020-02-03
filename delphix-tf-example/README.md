# Create a basic Delphix environment on IBM Cloud VPC Gen 2

## Overview

This Terraform configuration will create a basic Delphix environment running in a VSI on IBM Cloud VPC, consisting of:
- 1 VPC, with 3 Zones
- 1 Security Group
- 3 Address Prefixes
- 3 Subnets
- 1 Virtual Server Instance
- 1 Floating IP

## Setup

See the following for information on using the IBM Cloud Terraform provider
- https://cloud.ibm.com/docs/terraform?topic=terraform-setup_cli

You will need to have imported the Delphix image into your IBM Cloud VPC environment. See this page for details:
- https://cloud.ibm.com/docs/vpc?topic=vpc-managing-images
- This could also be done through Terraform, but currently isn't. See: https://ibm-cloud.github.io/tf-ibm-docs/v0.20.0/r/is_images.html


You will need to configure variables in the terraform.tfvars and variables.tf file to match your environment requirements. Example variables you'll need to set:

`image`: name of the Delphix image that was uploaded
`resource_group`: the ID of the resource group to use
`remote_access_addr`: the IP address or CIDR block to be allowed public access to the Delphix VSI


## Running Terraform

Initialize Terraform by running `terraform init`

Review the changes by running `terraform plan`

Apply the changes to your IBM Cloud account by running the `terraform apply` command