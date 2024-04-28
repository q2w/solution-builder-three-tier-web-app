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
  * Adding service account for GCE VM MIG
  * Adding access-config for external IP address

Update in VM composition unit can be seen here. https://github.com/ayushmjain/terraform-google-solution-builder-vm/pull/1/files

* Preparing comparable startup-script for VM to start frontend and backend service.

Frontend startup script:

```
frontend_startup_script = <<-EOF
        apt-get update
        apt-get install -y docker.io
        gcloud auth configure-docker
        docker pull gcr.io/abhiwa-test-30112023/three-tier-app-fe:1.0.2
        docker run --env-file /tmp/docker-env.txt -d --network host --name backend-service gcr.io/abhiwa-test-30112023/three-tier-app-fe:1.0.2
    EOF
```

Backend startup script:

```
backend_startup_script = <<-EOF
        apt-get update
        apt-get install -y docker.io
        gcloud auth configure-docker
        docker pull gcr.io/abhiwa-test-30112023/three-tier-app-be:1.0.2
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
        docker run -e PORT="8080" --env-file /tmp/docker-env.txt -d --network host --name backend-service gcr.io/abhiwa-test-30112023/three-tier-app-be:1.0.2
    EOF
```

* Using load balancer composition unit to distribute traffic between instances of managed instance group

#### How to run this solution

1. Create docker images for frontend and backend. 

    a. Run `gcloud builds submit --config=./cloudbuild.yaml` in ./src directory.

    b. The above command will create docker images named `three-tier-app-fe` and 
`three-tier-app-be`

2. Run `terraform apply` command for deployment and use the newly created images.
You can use above given startup_script for frontend and backend. You can modify
the startup script accordingly with the image tag etc. 
3. You will get an IP address as output. You can open http://IP-address. It
will open TODO page.

