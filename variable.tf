variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.124.0.0/16"  
}

# FIX: Changed type to list(string) and default to a list value.
variable "access_ip" {
    description = "The IP address allowed to access the resources"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

variable "instance_type" {
    description = "The type of instance to use for the web server"
    type        = string
    default     = "t2.micro"
}

# FIX: Added the missing main_instance_count variable.
variable "main_instance_count" {
    description = "Number of main instances to create"
    type        = number
    default     = 1
}

variable "key_name" {
    description = "The name of the key pair"
    type        = string
    default     = "id_rsa"
}

# variable "public_key_path" {
#     description = "The path to the public key file"
#     type        = string
#     # FIX: Use quotes and forward slashes for the path
#     default     = "C:/Users/Aditya Kumar/.ssh/id_rsa.pub" 
# }
variable "private_key_path" {
    description = "The path to the private key file"
    type        = string
    # FIX: Changed the default value from Windows path to the Linux path.
    default     = "/home/aadii_linux/.ssh/id_rsa_wsl"
}
# variable "private_key_path" {
#     description = "The path to the private key file"
#     type        = string
#     # FIX: Use quotes and forward slashes for the path
#     default     = "C:/Users/Aditya Kumar/.ssh/id_rsa"
# }
variable "public_key_path" {
    description = "The path to the public key file"
    type        = string
    # FIX: Use the Linux path where the public key is accessible on the Jenkins agent.
    default     = "/home/aadii_linux/.ssh/id_rsa_wsl.pub" 
}