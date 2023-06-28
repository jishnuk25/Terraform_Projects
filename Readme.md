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

    ex:

        resource "google_compute_instance" "client" {
    
        depends_on = [ google_compute_instance.server ]
        }

        resource "google_compute_instance" "server" {
        
        }

    note: in the above case the dependecy wouldn't be visible to terraform hence we have to provide it explicitly

- lifecycle: define a lifecycle of resource. ex: high availability(spin up a resource before the current resource goes up, etc.)
