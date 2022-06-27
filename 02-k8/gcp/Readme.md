### Deploy k8s cluster


# 1. Init google
```
gcloud init
```

Next ensure the required APIs are enabled in your GCP project:
# 2. Enable google services
```
gcloud services enable storage-api.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable iam.googleapis.com
```

# 3. Prepeare enviroment variables
```
cp terraform.tfvars.example terraform.tfvars
```

### Service Account

# 4. Create service account with deployer-keys. Keep eye on permission level --role "roles/editor"
```
PROJECT_ID=[ID OF YOUR PROJECT] # bananaz-dev-deploy
gcloud iam service-accounts create terraform
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member "serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com" --role "roles/editor"
gcloud iam service-accounts keys create key.json --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/key.json"
```

**Keep the key file in a safe place, and do not share or publicise it.**

## Remote Terraform State

Next create a GCS Bucket that will be used to hold Terraform state information.
Using [remote Terraform state](https://www.terraform.io/docs/state/remote.html)
makes it easier to collaborate on Terraform projects.
The storage bucket name must be globally unique, the suggested name is `{PROJECT_ID}-terraform-state`.
After creating the bucket update the IAM permissions to make the `terraform` service account an `objectAdmin`.

# 5. Setup more variables, create "bucket" on google platform to save terraform state remotely.
```
REGION="us-central1"
BUCKET_NAME="${PROJECT_ID}-terraform-state"
gsutil mb -l ${REGION} gs://${BUCKET_NAME}
gsutil iam ch serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com:objectAdmin gs://${BUCKET_NAME}
```

# 6. Initialize local terraform
```
    terraform init -backend-config=bucket=${BUCKET_NAME}
```


### Applying
Now that Terraform is setup check that the configuration is valid:

# 7. Validate code
```
    terraform validate
```

# 8. Pre-apply. Use to see what gonna be changed on next apply, some kind of diff between current and next stage.
```
    terraform plan
```

If the configuration is valid then apply it with:

# 9. Apply configurations to remote cluster
```
    terraform apply
```

Inspect the output of apply to ensure that what Terraform is going to do what you want, if so then enter `yes` at the prompt.
The infrastructure will then be created, this make take a some time.

### Clean Up
Remove the infrastructure created by Terraform with:


# 10. Remove cluster from GCP
```
    terraform destroy
```

Sometimes Terraform may report a failure to destroy some resources due to dependencies and timing contention.
In this case wait a few seconds and run the above command again.
If it is still unable to remove everything it may be necessary to remove resources manually using the `gcloud` command or the Cloud Console.

# 11. Remove state artifacts.
The GCS Bucket used for Terraform state storage can be removed with:

```
    gsutil rm -r gs://${BUCKET_NAME}
```

## How to connect kubectl cluster.

### Findout name of your k8s cluster.
```
    gcloud container clusters list

    NAME                          LOCATION     MASTER_VERSION    MASTER_IP      MACHINE_TYPE  NODE_VERSION      NUM_NODES  STATUS
    %project_cluster_name%  us-central1  1.21.10-gke.2000  34.134.246.23  g1-small      1.21.10-gke.2000  3          RUNNING
```

### Store creds in your environment.
```
    gcloud container clusters get-credentials %project_cluster_name% --region us-central1 --project %project_name%
```

### Validate does it work well
```
    kubectl cluster-info
```


#### TODO
- enable backups for cluster
- add argocd as default chart onloading https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
- add new repository with helm charts
