variable "ami" {
  description = "The AMI for the instance"
  default     = "ami-053b0d53c279acc90"
  type        = string
}

variable "instances_number" {
  description = "Number of instances to lunch (default is 1)"
  default     = 1
  type        = number
}

variable "instance_type" {
  description = "Instance type to lunch (default it t2.micro)"
  default     = "t2.micro"
  type        = string
}