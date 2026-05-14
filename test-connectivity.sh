#!/bin/bash
 
# Get VPC ID
VPC_ID=$(terraform output -raw vpc_id)
 
# Test 1: Verify VPC
echo "=== VPC Details ==="
aws ec2 describe-vpcs --vpc-ids $VPC_ID

"
=== VPC Details ===
{
    "Vpcs": [
        {
            "OwnerId": "845587649055",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-04492ba14b6e7f76b",
                    "CidrBlock": "10.0.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": false,
            "Tags": [
                {
                    "Key": "Environment",
                    "Value": "dev"
                },
                {
                    "Key": "Name",
                    "Value": "networking lab- dev-vpc"
:...skipping...
{
    "Vpcs": [
        {
            "OwnerId": "845587649055",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-04492ba14b6e7f76b",
                    "CidrBlock": "10.0.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": false,
            "Tags": [
                {
                    "Key": "Environment",
                    "Value": "dev"
                },
                {
                    "Key": "Name",
                    "Value": "networking lab- dev-vpc"
                }
:...skipping...
{
    "Vpcs": [
        {
            "OwnerId": "845587649055",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-04492ba14b6e7f76b",
                    "CidrBlock": "10.0.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": false,
            "Tags": [
                {
                    "Key": "Environment",
                    "Value": "dev"
                },
                {
                    "Key": "Name",
                    "Value": "networking lab- dev-vpc"
                }
            ],
            "BlockPublicAccessStates": {
                "InternetGatewayBlockMode": "off"
            },
            "VpcId": "vpc-0db5b43f33265308a",
:...skipping...
{
    "Vpcs": [
        {
            "OwnerId": "845587649055",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-04492ba14b6e7f76b",
                    "CidrBlock": "10.0.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": false,
            "Tags": [
                {
                    "Key": "Environment",
                    "Value": "dev"
                },
                {
                    "Key": "Name",
                    "Value": "networking lab- dev-vpc"
                }
            ],
            "BlockPublicAccessStates": {
                "InternetGatewayBlockMode": "off"
            },
            "VpcId": "vpc-0db5b43f33265308a",
            "State": "available",
            "CidrBlock": "10.0.0.0/16",
            "DhcpOptionsId": "dopt-03ace805e9ff4da05"
        }
    ]
:...skipping...
{
    "Vpcs": [
        {
            "OwnerId": "845587649055",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-04492ba14b6e7f76b",
                    "CidrBlock": "10.0.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": false,
            "Tags": [
                {
                    "Key": "Environment",
                    "Value": "dev"
                },
                {
                    "Key": "Name",
                    "Value": "networking lab- dev-vpc"
                }
            ],
            "BlockPublicAccessStates": {
                "InternetGatewayBlockMode": "off"
            },
            "VpcId": "vpc-0db5b43f33265308a",
            "State": "available",
            "CidrBlock": "10.0.0.0/16",
            "DhcpOptionsId": "dopt-03ace805e9ff4da05"
        }
    ]
}
~
~
"


 
# Test 2: Count subnets
echo ""
echo "=== Subnet Count ==="
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[*].[Tags[?Key==`Name`].Value|[0]]' \
  --output text | wc -l
 
=== Subnet Count ===
       9

# Test 3: Verify NAT Gateway
echo ""
echo "=== NAT Gateways ==="
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" \
  --query 'NatGateways[*].[NatGatewayId,State,SubnetId]' \
  --output table
 
=== NAT Gateways ===
--------------------------------------------------------------------
|                        DescribeNatGateways                       |
+------------------------+------------+----------------------------+
|  nat-0d3103f7796d6062d |  available |  subnet-0e415a6b39817b9ce  |
+------------------------+------------+----------------------------+

# Test 4: Check route tables
echo ""
echo "=== Route Tables ==="
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[*].[RouteTableId,Tags[?Key==`Name`].Value|[0]]' \
  --output table


=== Route Tables ===
----------------------------------------------------------
|                   DescribeRouteTables                  |
+------------------------+-------------------------------+
|  rtb-097f460476278f0eb |  networking lab-database-rt   |
|  rtb-07be278d00e8194fb |  networking lab-private-rt-1  |
|  rtb-064966097eec26982 |  None                         |
|  rtb-0cdf7c5ab8297cd37 |  networking lab-public-rt     |
+------------------------+-------------------------------+