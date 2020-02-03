# provider configuration parameters/variables
provider "ibm" {
  ibmcloud_api_key = "${var.ibmcloud_api_key}"
  generation = 2
  region = "${var.region}"
  iaas_classic_username = "${var.iaas_classic_username}"
  iaas_classic_api_key  = "${var.iaas_classic_api_key}"
}
# create vpc instance referencing resource group in variables.tf
resource "ibm_is_vpc" "new_vpc" {
  name = "${var.vpcname}"
  resource_group = "${var.resource_group}"
}
# add rule to allow inbound ssh traffic from specified address or CIDR block 
resource "ibm_is_security_group_rule" "allow_ssh_limited" {
  group     = "${ibm_is_vpc.new_vpc.default_security_group}"
  direction = "inbound"
  remote    = "${var.remote_access_addr}"                       

  tcp = {
    port_min = 22
    port_max = 22
  }
}
# add rule to allow inbound HTTPS traffic from specified address or CIDR block 
resource "ibm_is_security_group_rule" "allow_https_limited" {
  group     = "${ibm_is_vpc.new_vpc.default_security_group}"
  direction = "inbound"
  remote    = "${var.remote_access_addr}"                       

  tcp = {
    port_min = 443
    port_max = 443
  }
}
# create 2 vpc address prefixes in zones 1 and 3 referencing the vpc
resource "ibm_is_vpc_address_prefix" "new_vpc_address_prefix" {
  count = 2
  name = "${var.cidrnameprefix}-${count.index + 1}"
  zone = "${var.region}-${count.index + 1}"
  vpc = "${ibm_is_vpc.new_vpc.id}"
  cidr = "${var.cidraddresslist[count.index]}"
}

# create 2 subnets in zones 1 and 3 referencing the address prefixes and vpc
resource "ibm_is_subnet" "new_subnet" {
  count = 2
  name = "${var.subnetnameprefix}-${count.index + 1}"
  vpc  = "${ibm_is_vpc.new_vpc.id}"
  zone = "${var.region}-${count.index + 1}"
  ipv4_cidr_block = "${var.subnetlist[count.index]}"
  depends_on = ["ibm_is_vpc_address_prefix.new_vpc_address_prefix"]
}
# make ssh key details visible by using name in variables.tf
data ibm_is_ssh_key "ssh_key_id" {
  name = "${var.ssh_key}"
}
# make OS image details visible by using name in variables.tf
data ibm_is_image "image_id" {
  name = "${var.image}"
}
# create 4 volumes for the Delphix VSI
resource "ibm_is_volume" "new_volume" {
  count = 4
  name = "${var.volumenameprefix}-${count.index + 1}"
  profile = "${var.volumeprofile}"
  zone = "${var.region}-1"
  capacity = "${var.volumesize}"
}

# create VSI in zone 1 referencing all of the above
resource ibm_is_instance "zone1new_vsi" {
  count   = "${var.zone1vsicount}"
  name    = "${var.region}-1-${var.vsinameprefix}-${count.index + 1}"
  vpc     = "${ibm_is_vpc.new_vpc.id}"
  zone    = "${var.region}-1"
  keys    = ["${data.ibm_is_ssh_key.ssh_key_id.id}"]
  image   = "${data.ibm_is_image.image_id.id}"
  profile = "${var.profile}"
#  volumes = ["${join(", ", ibm_is_volume.new_volume.*.id)}"]
  volumes = ["${element((ibm_is_volume.new_volume.*.id), 0)}",
            "${element((ibm_is_volume.new_volume.*.id), 1)}",
            "${element((ibm_is_volume.new_volume.*.id), 2)}",
            "${element((ibm_is_volume.new_volume.*.id), 3)}"
  ]

  primary_network_interface = {
    subnet          = "${element((ibm_is_subnet.new_subnet.*.id), 0)}"
    security_groups = ["${ibm_is_vpc.new_vpc.default_security_group}"]
  }
}

# Create a floating IP for the Delphix VSI in zone 1
resource ibm_is_floating_ip "zone1fip" {
  count = "${var.zone1vsicount}"
  name   = "${var.floatingipnameprefix}-${count.index + 1}"
  target = "${element((ibm_is_instance.zone1new_vsi.*.primary_network_interface.0.id), count.index)}"
}

# Print the floating IP for the Delphix VSI
output "floatingipvaluezone1" {
  value = "${ibm_is_floating_ip.zone1fip.*.address}"
  
}
