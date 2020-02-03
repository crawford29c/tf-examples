variable "ibmcloud_api_key" {
  # defined in tfvars
}
variable "ssh_key" {
  # defined in tfvars
}

variable "iaas_classic_username" {
 # defined in tfvars
}

variable "iaas_classic_api_key" {
  # defined in tfvars
}
variable "region" {
  # default region to be used
    default = "us-south"
}

variable "image" {
  # Delphix OS image to be used
    default = "delphix-6"
}
variable "profile" {
  # default compute profile to be used
    default = "mx2-16x128"
}
variable "volumeprofile" {
  # default volume profile to be used
    default = "10iops-tier"
}
variable "volumesize" {
  # default volume size to be used
    default = "25"
}
variable "resource_group" {
  # use default or whatever valid resource name in your account
  default = "6d5e558f1c854562988ef67a5fec0439"
}
variable "vpcname" {
  # default vpc name to be used
  default = "delphix-vpc"
}
variable "volumenameprefix" {
  # default vsi name prefix to be used
  default = "dxvol"
}
variable "vsinameprefix" {
  # default vsi name prefix to be used
  default = "delphix"
}
variable "cidrnameprefix" {
  # default cidr name prefix to be used
  default = "prefix"
}
variable "cidraddresslist" {
  default = [
    # cidr address prefixes to be used
    "172.16.0.0/16",
    "192.168.0.0/16",
    "10.10.0.0/16"
  ]
}

variable "subnetlist" {
  default = [
    # subnets derived address prefixes to be used
    "172.16.0.0/24",
    "192.168.0.0/24",
    "10.10.0.0/24"
  ]
}

variable "remote_access_addr" {
  # default IP address or CIDR block to be allowed to access the Delphix VSI
  default = "127.0.0.1"
}

variable "subnetnameprefix" {
  # default subnet name prefix to be used
  default = "subnet"
}
variable "floatingipnameprefix" {
  # default floating IP name prefix to be used
  default = "fip"
}
variable "zone1vsicount" {
  # number of vsis to be provisioned in zone 1
  default = 1
}
