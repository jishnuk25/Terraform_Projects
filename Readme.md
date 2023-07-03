---Terraform(IaC)---

Iac Config workflow

Scope(confirms the resources required for the project)-->Author(Author the config files based on the scope)-->Initialize(download the provider plugin and initialize directory)-->Plan(view execution plan for resorces created/modified/deleted)-->Apply(create actual resources)
---
place similiar type of resources in a directory and define the resources in a main.tf(root configuration)

Meta arguments - customize the behaviour of resources
- count: create multiple instances according to the value assigned to the count
    ex:

        resource "google_compute_instance" "Dev_VM" {
            count = 5
            name = "dev_VM{count.index + 1}"
        }

- for_each: create multiple resource instances as per a set of strings
    ex: 
    
        resource "google_compute_instance" "dev_vm" {
            for_each = toset( ["us-central-1", "asia-east-1-b", "europe-west4-a"] )
            name = "dev-${each.value}"
            zone =  each.value
        }

- depends_on: specify explicit dependency. ex: a given resource can be created only after availability of another resource
                (static   ip created first then instance to be created where the static ip is being assigned to the instance)
    
    implicit dependency

        resource "google_compute_instance" "my_instance" {

            network_interface {
                //implicit dependency -- the reference to the my_network in the network argument creates an implicit dependency automatically
                network = google_compute_network.my_network.name
                access_config {
            
                }
            }
        }

        resource "google_compute_network" "my_network" {
            name = "my_network"
        }            

    explicit dependency

        resource "resource_type" "resource_name" {
    
        depends_on = [ <resource_type>.<resource_name> ]

        }

    ex1:

        resource "google_compute_instance" "client" {
    
        depends_on = [ google_compute_instance.server ]
        }

        resource "google_compute_instance" "server" {
        
        }

    note: in the above case the dependecy wouldn't be visible to terraform hence we have to provide it explicitly
    
    ex2:

        resource "google_compute_address" "vm_static_ip" {
            name = "terraform-static-ip"
        }
        resource google_compute_instance "vm_instance" {
            name         = "${var.instance_name}"
            zone         = "${var.instance_zone}"
            machine_type = "${var.instance_type}"
            boot_disk {
                initialize_params {
                image = "debian-cloud/debian-11"
                }
            }
            network_interface {
                network = "default"
                access_config {
                # Allocate a one-to-one NAT IP to the instance
                nat_ip = google_compute_address.vm_static_ip.address
                }
            }
        }
        
- lifecycle: define a lifecycle of resource. ex: high availability(spin up a resource before the current resource goes up, etc.)

---

Variables

ways to assign values to variables-

# .tfvars file(recommended method)
    $ tf apply -var-file my-vars.tfvars
# CLI options
    $ tf apply -var project_id="my-project"
# environment variables
    $ TF_VAR_project_id="my-project" \
      tf apply
# if using terraform.tfvars
    $ tf apply

If no variable values are assigned after declaration, the cli would prompt you to enter the value during the plan phase.

    ex:

        variable "mybucket_storageclass" {
            type = string
            description = "Set your storage class value here"
        }

validate variable values by using rules

    ex:

        variable "mybucket_storageclass" {
            type    = string
            description = "set the storage class to the bucket"
            validation {
                condition = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL"], var.mybucket_storageclass)
                error_message = "The allowed values are STANDARD, MULTI_REGIONAL, REGIONAL"
            }
        }

---

output values

We can print resource attributes using output values

    ex:

        resource "google_storage_bucket_object" "Picture" {
        ...  
        }

        output "picture_URL" {
        description = "URL of the picture uploaded"
        //value = <resource_type>.<resource_name>.<attribute>
        value = google_storage_bucket_object.Picture.self_link
        }

 $ terraform output -- queries all outputs used in the current project