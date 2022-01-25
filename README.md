# Introduction to Terraform


## Install Terraform

On a Mac OS, one can use homebrew package manager to install Terraform as shown below
`brew install terraform`

Once installed, verify your installation by gathering the version of terraform installed.

```
❯ terraform -v
Terraform v1.1.3
on darwin_arm64
+ provider registry.terraform.io/hashicorp/aws v3.72.0

Your version of Terraform is out of date! The latest version
is 1.1.4. You can update by downloading from https://www.terraform.io/downloads.html
```

## Configure AWS provider

https://registry.terraform.io/providers/hashicorp/aws/latest/docs


## Publish project

## Create VPC and subnets 

Gather the current state by issuing 

```
> terraform state list
```

 ###  Create VPC


Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

```
resource "aws_vpc" "playground" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "playground"
  }
}
```

```

❯ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.playground will be created
  + resource "aws_vpc" "playground" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "playground"
        }
      + tags_all                             = {
          + "Name" = "playground"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.playground: Creating...
aws_vpc.playground: Creation complete after 5s [id=vpc-041f969f9c64bf891]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

```

### Create subnet

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

Use AWS CLI to gather all availibility zones for a region of choice as shown below

```
❯ aws ec2 describe-availability-zones --region eu-west-1
{
    "AvailabilityZones": [
        {
            "State": "available",
            "OptInStatus": "opt-in-not-required",
            "Messages": [],
            "RegionName": "eu-west-1",
            "ZoneName": "eu-west-1a",
            "ZoneId": "euw1-az1",
            "GroupName": "eu-west-1",
            "NetworkBorderGroup": "eu-west-1",
            "ZoneType": "availability-zone"
        },
        {
            "State": "available",
            "OptInStatus": "opt-in-not-required",
            "Messages": [],
            "RegionName": "eu-west-1",
            "ZoneName": "eu-west-1b",
            "ZoneId": "euw1-az2",
            "GroupName": "eu-west-1",
            "NetworkBorderGroup": "eu-west-1",
            "ZoneType": "availability-zone"
        },
        {
            "State": "available",
            "OptInStatus": "opt-in-not-required",
            "Messages": [],
            "RegionName": "eu-west-1",
            "ZoneName": "eu-west-1c",
            "ZoneId": "euw1-az3",
            "GroupName": "eu-west-1",
            "NetworkBorderGroup": "eu-west-1",
            "ZoneType": "availability-zone"
        }
    ]
}
```

In Terraform code, create a subnet within the VPC as shown below 

```

resource "aws_subnet" "playground-subnet-1" {
  vpc_id     = aws_vpc.playground.id
  cidr_block = "10.0.16.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "playground-subnet-1"
  }
}

data "aws_vpc" "playground-vpc" {
  filter {
    name   = "tag:Name"
    values = ["playground"]
  }
}


resource "aws_subnet" "playground-subnet-2" {
  vpc_id     = data.aws_vpc.playground-vpc.id
  cidr_block = "10.0.32.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "playground-subnet-2"
  }
}

resource "aws_subnet" "playground-subnet-3" {
  vpc_id     = data.aws_vpc.playground-vpc.id
  cidr_block = "10.0.48.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "playground-subnet-3"
  }
}
```

```
❯ terraform apply
aws_vpc.playground: Refreshing state... [id=vpc-041f969f9c64bf891]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_subnet.playground-subnet-1 will be created
  + resource "aws_subnet" "playground-subnet-1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.16.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "playground-subnet-1"
        }
      + tags_all                                       = {
          + "Name" = "playground-subnet-1"
        }
      + vpc_id                                         = "vpc-041f969f9c64bf891"
    }

  # aws_subnet.playground-subnet-2 will be created
  + resource "aws_subnet" "playground-subnet-2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.32.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "playground-subnet-2"
        }
      + tags_all                                       = {
          + "Name" = "playground-subnet-2"
        }
      + vpc_id                                         = "vpc-041f969f9c64bf891"
    }

  # aws_subnet.playground-subnet-3 will be created
  + resource "aws_subnet" "playground-subnet-3" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.48.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "playground-subnet-3"
        }
      + tags_all                                       = {
          + "Name" = "playground-subnet-3"
        }
      + vpc_id                                         = "vpc-041f969f9c64bf891"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_subnet.playground-subnet-3: Creating...
aws_subnet.playground-subnet-1: Creating...
aws_subnet.playground-subnet-2: Creating...
aws_subnet.playground-subnet-2: Creation complete after 2s [id=subnet-0b2bff066da415c44]
aws_subnet.playground-subnet-3: Creation complete after 2s [id=subnet-0edb219ba90ac4924]
aws_subnet.playground-subnet-1: Creation complete after 2s [id=subnet-0bff89a17a2062f39]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```