variable "rgname" {
   type = string
   description ="Resource group name"

}

variable "rglocation" {
   type = string
   description = "Resource Group Location"
   default = "East Us"

}

variable "vnet_cidr_prefix" {
   type = string
   description = "Virtual network cidr prefix"

}

variable "subnet_cidr_prefix" {
   type = string
   description = "Subnet cidr prefix"
}

variable "user_name" {
   type = string
   description = "Admin User name"
}

variable "vm_size" {
   type = string
   description = "Size of VM to be created"
}

variable "vm_name" {
   type = string
   description = "Azure VM Resource Name"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "nsg_name" {
   type = string
   description = "Network Security Group name"
}

variable "pub_ip" {
   type = string
   description = "Public Ip address of VM to be created"
}

variable "nic_name" {
   type = string
   description = "name of nic to be created"
}

variable "subnet_name" {
   type = string
   description = "Subnet name of VM to be created"
}

variable "vnet_name" {
   type = string
   description = "Virtual Network Name of VM to be created"
}

variable "computer_name" {
   type = string
   description = "Host Name of VM to be created"
}
