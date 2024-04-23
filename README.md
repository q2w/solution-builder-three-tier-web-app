#### About
This repository holds three-tier-web-app solution terraform config.
It uses composition units to formulate the solution. In this repository, we are using GCE managed-instance-group with load-balancers instead
of cloud-run for service stack.

#### Motivation
We already have three-tier-web-app solution present at https://github.com/ayushmjain/solution-builder-three-tier-web-app.
In the above repo, we are using cloud-run for running our service stack. Frontend and backend 
services present in three-tier-web-app are using cloud-run.
In this repository, we are exploring flexibility of three-tier-web-app by using GCE VMs 
instead of cloud-run.

#### Evolution of this solution

Base composition unit for VM is present at https://github.com/ayushmjain/terraform-google-solution-builder-vm

Base composition unit for load balancer is present at https://github.com/ayushmjain/terraform-google-solution-builder-external-application-load-balancer

Base three-tier-web-app using cloud-run is preset at https://github.com/ayushmjain/solution-builder-three-tier-web-app.

##### Changes done for using VM in-place of cloud run

* Updating VM composition unit to have 
  * Firewall rules for allowing access 
  * Adding source_image_project 
  * Adding access-config for external IP address

Update in VM composition unit can be seen here. https://github.com/ayushmjain/terraform-google-solution-builder-vm/pull/1/files

* Creation of GCE VM image for frontend and backend services. We have updated
cloudbuild.yml files for frontend and backend.

* Preparing comparable startup-script for VM to start frontend and backend service.

* Using load balancer composition unit to distribute traffic between instances of managed instance group

##### Assumption

* To create VM image for frontend and backend, cloudbuild service account requires
below permissions,
```
gcloud projects add-iam-policy-binding PROJECT_ID \
--member='serviceAccount:PROJECT_NUMBER@cloudbuild.gserviceaccount.com' \
—role='roles/compute.instanceAdmin.v1'
--role='roles/compute.osLogin'
--role='roles/iam.serviceAccountUser'
```

##### Future exploration
* Explore using docker image of frontend and backend inside VM instance. 
This would simplify application update. In this repo, we are creating a new VM image for update.


#### How to run this solution

1. Create VM image for frontend and backend. 
   
   a. Firstly give cloud build service account permission using below command.

    ```
    gcloud projects add-iam-policy-binding PROJECT_ID \
    --member='serviceAccount:PROJECT_NUMBER@cloudbuild.gserviceaccount.com' \
    —role='roles/compute.instanceAdmin.v1'
    --role='roles/compute.osLogin'
    --role='roles/iam.serviceAccountUser'
   
    ```

    b. Run `gcloud builds submit --config=./cloudbuild.yaml` in ./src/frontend and 
./src/middleware directory.

    c. The above command will create VM image named `three-tier-app-fe` and 
`three-tier-app-be`

2. Run `terraform apply` command for deployment and use the newly created images.
3. You will get an IP address as output. You can open http://IP-address. It
will open TODO page.

