Route table: Route table is a virtual router in VPC, which determines the destination to which the traffic must be forwarded within the VPC. In AWS, whenever one creates a VPC, a route table is automatically created for it when not explicitly specified. By default, the VPC isn't connected to the internet. The route table only manages ip-address range specified in CIDR block for resources with the VPC. For a route-table to handle traffic from and to the internet, it must be connected to an internet gateway. An internet gateway, as the name suggests, manages internet connectivity for a VPC. 

Network access control list (NACL) is a firewall configuration for subnets within a VPC; which consists of inbound and outbound rules. They control inbound and outbound traffic for a subnet. By default, NACLs do not restrict any incoming or outgoing traffic. 

Security group is a similar firewall that is attached to a network interface card (NIC); which is attached to an EC2 instance. Simply put, they control inbound and outbound traffic from an EC2 instance. Security group on the other hand is closed by default in terms of allowing traffic. 

Terraform creates the necessary components in the right sequence. 

Traffic within and between the subnets should also be handled by route table. Configure "subnet-associations" for it. Subnets get automatically assigned to the main or default route table. 

Subnet must be connected with the internet gateway. 