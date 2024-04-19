#### About
This repository holds three-tier-web-app solution terraform config.
It uses composition units to formulate the solution. In this repository, we are using GCE managed-instance-group instead
of cloud-run for service stack.

#### Motivation
We already have three-tier-web-app solution present at https://github.com/ayushmjain/solution-builder-three-tier-web-app.
We are cloud-run for running our service stack. Frontend and backend 
service present in three-tier-web-app is using cloud-run.
In this repository, we are exploring flexibility of three-tier-web-app by using GCE VMs 
instead of cloud-run.

#### Evolution of this solution

Base composition unit for VM is present at https://github.com/ayushmjain/terraform-google-solution-builder-cloud-run/tree/main

Base three-tier-web-app using cloud-run is preset at https://github.com/ayushmjain/solution-builder-three-tier-web-app.

We have copied different composition units into ./infra/modules folder for composing the solution.
The solution in this repo differs as we are using VMs in-place of cloud-run. 

##### Changes done for using VM in-place of cloud run

* Updating VM composition unit to have 
  * Firewall rules for allowing access 
  * Adding source_image_project 
  * Adding access-config for external IP address

    
We have updated ./infra/modules/terraform-google-solution-builder-vm for this purpose. 

* Creation of GCE VM image for frontend and backend services. We have updated
cloudbuild.yml files for frontend and backend.

* Preparing comparable startup-script for VM to start frontend and backend service.

##### Assumption

* In this solution, we are only creating 1 instance for each MIG of frontend and backend.
We are using external IP address of the instances for communication.
* To create VM image for frontend and backend, cloudbuild service account requires
below permissions,
```
gcloud projects add-iam-policy-binding PROJECT_ID \
--member='serviceAccount:PROJECT_NUMBER@cloudbuild.gserviceaccount.com' \
—role='roles/compute.instanceAdmin.v1'
--role='roles/compute.osLogin'
--role='roles/iam.serviceAccountUser'
```
* Backend and frontend external IP is accessible to public via external IP address.
##### Future exploration
* Use load balancers in-front-of backend and frontend MIG.
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

