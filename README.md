# Postgres database load balancing

The design uses Haproxy as the load balancer. Postgres is the database application. Packer is used to create an image for the load balancer, another for the master and the other for two slaves. The implementation is configured to run with GCP

#### creating images using packer

clone the repository, export the service account key, and the GCP project id. Also fill in the appropriate variables in the `.env` file.

```
git clone https://github.com/philophilo/postgres-loadbalancing.git
cd postgres-loadbalancing
export SERVICE_ACCOUNT_PATH="path_to_service_account"
export PROJECT_ID="GCP_project_id"
```

create the Haproxy image

```
cd images/haproxy/
# validate the script
packer validate haproxy.json
# build the image
packer build haproxy.json
```


create the master image

```
cd images/master/
# validate the script
packer validate master.json
# build the image
packer build master.json
```


create the slave image

```
cd images/haproxy/
# validate the script
packer validate slave.json
# build the image
packer build slave.json
```

#### creating the infrastructure on GCP with terraform

change the directory to the terraform and run terraform

```
cd terraform
# initialize terraform
terraform init
# view the plan
terraform plan
# build the resources
terraform apply
```
