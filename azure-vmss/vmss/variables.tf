variable "prefix" {
  type = string
  description = "Provide the Prefix name to be used."
}

variable "location" {
  type = list
  description = "Provide the Azure Location into which the REsource to be created."
}

################################################################# Variables for Azure VM ##############################################################

variable "vm_count" {
  description = "Provide the number of Azure VMs to be launched"
  type = number
}

variable "vm_size" {
  type = list
  description = "Provide the Size of the Azure VM"
}

variable "availability_zone" {
  type = list
  description = "Provide the Availability Zone into which the VM to be created"
}

variable "static_dynamic" {
  type = list
  description = "Select the Static or Dynamic"
}

variable "disk_size_gb" {
  type = number
  description = "Provide the Disk Size in GB"
}

variable "extra_disk_size_gb" {
  type = number
  description = "Provide the Size of Extra Disk to be Attached"
}

variable "computer_name" {
  type = string
  description = "Provide the Hostname"
}

variable "admin_username" {
  type = string
  description = "Provid the Administrator Username"
}

variable "admin_password" {
  type = string
  description = "Provide the Administrator Password"
}

variable "env" {
  type = list
  description = "Provide the Environment for AKS Cluster"
}
