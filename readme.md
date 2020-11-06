## 1. Terraform

you can execute the following code using the following commands.

`terraform init`

`terraform apply -var-file=environments/demo.tfvars --auto-approve`

The bucket names are passed as values from the file demo.tfvars under environments folder. We have written the s3 module to create the bucket on the  basis on number of names given in the demo.tfvars.

In this case we have given 3 names so it would go ahead and create 3 buckets.

### Key Assumptions

I assume that there are existing policies and getting them using `data` and assigning them to the bucket.

Reason I have not created IAM policies in the same module is , I want to segregate modules either based on the services or common infra functionality.
Example I can have a module called `network` and include VPC,subnets, routetables etc.

since there is no logical grouping between IAM and s3 I have decided not to include IAM roles/policies in this module.

you can destroy the resources using:

`terraform destroy -var-file=environments/demo.tfvars --auto-approve` 

## 2. Helm Chart

The proposed helm chart deploys nginx running on single pod. The helm chart contains the following items:

1. Deployment
2. Service
3. HPA (Horizontal pod Auto scaling)
4. Ingress
5. Secrets

We can install the helm chart using the following command:

`helm install  demo demo-stateless-application -f demo-stateless-application/stage.yaml`

stage.yaml and production.yaml typically represents different environmental values for the application.

### Note:

For the secrets I have used plain text as it is a demo purpose. It is not a good practice to store secrets in plain text and push them to git.

For this purpose we can use services like KMS encrypt the secrets and push them to git and decrypt them while reading. 

https://github.com/mozilla/sops This is a good tool that I have came across which makes all the operations related to decryption and encryption relatively easy,