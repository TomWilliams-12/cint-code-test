# Lucid HQ Infrastructure Terraform Code Test #

Using AWS and the Terraform in this repository create a simple web server with associated database.

The terraform code to create the basic networking (VPC and subnets...) has been provided in `network.tf`.


## Tom Williams CINT Code Test

Required:
1. ALB
    - Port 80 to TG
1. ASG
    - min 2 instances
    - desired 2 instances
    - t2.nano linux ami
    - Scale to ALB TG
    - connect to RDS
1. RDS connection

Work Done:
1. alb.tf:
    - Created target group
    - Created application load balancer in the public subnets
    - Added listener on Port 80 with forward to target group

1. compute.tf:
    - Added data block that filters for latest amazon ami
    - Created EC2 Launch template
        - Injected user data script that installs nginx. This was to ensure I could access port 80
    - Created autoscaling group using the launch template on the private subnets

1. iam.tf:
    - created IAM role for the EC2 launch template to assume. The idea behind this was to enable the EC2's access to the database credentials. This remained untested so unsure if this works but the simulation for the policy was working as intended

1. rds.tf:
    - created a subnet group from the private subnets in the VPC
    - created a database instance 
    - uploaded the username and password to secrets manager

1. securitygroups.tf:
    - created load balancer security group that allows port 80 inbound from anywhere and everything outbound 
    - created autoscaling config security group for the EC2 instances that allows port 80 inbound only from the load balancer and everything outbound.
    - created RDS security group that allows only the allocated port number that is used in the variable e.g 5432 for postgres and everything outbound

1. userdata.tpl:
    - install nginx
    - install postgresql


### Questions:
#### How do future applications get ALB DNS name to use the service?
I believe this can be achieved by using a module. You are able to access outputs from other modules using the syntax "module.object.output".

If the system is in a separate codebase then you are able to import the outputs from a state file using terraform_remote_state in a data block.

#### How does this Terraform work in a pipeline?
It is not best practice to use tfvars in a pipeline and should be explicitily declared as variables in the terraform init command.

There are some secrets within this terraform such as the master database password that you would want to ensure remains encrypted throughout the pipeline. An example of this is setting all variables as secrets in an Azure pipeline both encrypting and masking them, this is best practice for my current position.

Providing the pipeline with least priviledge in order to perform its build tasks. This could prevent some unwanted activity such as deletion etc.

Lastly incorporating a backend state file and using terraform_remote_state will ensure that the terraform state remains consistent throughout the pipeline.


