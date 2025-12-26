data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"] # Canonicall
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}
resource "random_id" "random_node_id" {
    byte_length = 2
    count= var.main_instance_count

}
resource "aws_key_pair" "deployer_key" {
    key_name   = var.key_name
    public_key = file(var.public_key_path)

}
resource "aws_instance" "web_server" {
    count= var.main_instance_count
    ami=data.aws_ami.ubuntu.id
    instance_type=var.instance_type
    subnet_id=aws_subnet.public_subnet[count.index].id
    key_name=aws_key_pair.deployer_key.key_name
    vpc_security_group_ids=[aws_security_group.project_sg.id]
    user_data = templatefile("main-userdata.tpl", {
        new_hostname = "web-server-${random_id.random_node_id[count.index].dec}"
    })
    tags={
        Name="web-server-${random_id.random_node_id[count.index].dec}"   
    }
    provisioner "local-exec" {
        interpreter = [ "C://Program Files/Git/bin/bash.exe", "-c" ]
        command = "printf '\\n${self.public_ip}' >> aws_hosts"

    }
    provisioner "local-exec" {
        when = destroy
        interpreter = [ "C://Program Files/Git/bin/bash.exe", "-c" ]
        command = "sed -i '/^[0-9]/d' aws_hosts"
      
    }
}

locals {
  windows_key_path = var.private_key_path
}

resource "null_resource" "graphana_provisioner" {
    depends_on = [ aws_instance.web_server ]

    provisioner "remote-exec" {
        connection {
            type        = "ssh"
            host        = aws_instance.web_server[0].public_ip
            user        = "ubuntu"
            private_key = file(local.windows_key_path)
            timeout     = "5m"
        }
        inline = [ "echo 'Connection test successful Instance is reachable via ssh'" ]
    }

#     provisioner "local-exec" {
#         interpreter = ["wsl", "bash", "-c"]
#         command = <<EOT
#         sleep 30
#         mkdir -p ~/.ssh
#         cp "/mnt/c/Users/Aditya Kumar/.ssh/id_rsa" ~/.ssh/id_rsa_tmp
#         chmod 600 ~/.ssh/id_rsa_tmp
#         ansible all -i "${aws_instance.web_server[0].public_ip}," -u ubuntu --private-key ~/.ssh/id_rsa_tmp -m ping
#         rm ~/.ssh/id_rsa_tmp
#         EOT
#     }
#         resource "null_resource" "graphana_provisionerr" {
#   # ... (other settings) ...

   provisioner "local-exec" {
    interpreter = ["wsl", "bash", "-c"]
    command = "sleep 30; mkdir -p ~/.ssh; cp '/mnt/c/Users/Aditya Kumar/.ssh/id_rsa' ~/.ssh/id_rsa; chmod 600 ~/.ssh/id_rsa; export ANSIBLE_HOST_KEY_CHECKING=False; cd '/mnt/c/Users/Aditya Kumar/Downloads/MiniProject/MiniProject'; echo '=== Installing Grafana ==='; ansible-playbook -i '${aws_instance.web_server[0].public_ip},' --user ubuntu --private-key ~/.ssh/id_rsa -v grafana_playbook.yml; echo '=== Installing Prometheus ==='; ansible-playbook -i '${aws_instance.web_server[0].public_ip},' --user ubuntu --private-key ~/.ssh/id_rsa -v prometheus.yml"
}
# provisioner "local-exec" {
#   interpreter = ["/bin/bash", "-c"]
#   command = "sleep 30; mkdir -p ~/.ssh; cp /home/aadii_linux/.ssh/id_rsa_wsl ~/.ssh/id_rsa_wsl; chmod 600 ~/.ssh/id_rsa_wsl; export ANSIBLE_HOST_KEY_CHECKING=False; cd '/mnt/c/Users/Aditya Kumar/Downloads/MiniProject/MiniProject'; echo '=== Installing Grafana ==='; ansible-playbook -i '${aws_instance.web_server[0].public_ip},' --user ubuntu --private-key ~/.ssh/id_rsa_wsl -v grafana_playbook.yml; echo '=== Installing Prometheus ==='; ansible-playbook -i '${aws_instance.web_server[0].public_ip},' --user ubuntu --private-key ~/.ssh/id_rsa_wsl -v prometheus.yml"
# }
}
# CLEANER FIX from previous response (preferred)F
# provisioner "local-exec" {
#   interpreter = ["wsl", "bash", "-c"]
#   # Use tr -d '\r' to strip Windows carriage returns from the multiline command
#   command = <<-EOT
#     echo '
#     sleep 30;
#     mkdir -p ~/.ssh;
#     cp "/mnt/c/Users/Aditya Kumar/.ssh/id_rsa" ~/.ssh/id_rsa;
#     chmod 600 ~/.ssh/id_rsa;
#     export ANSIBLE_HOST_KEY_CHECKING=False;
#     cd /mnt/c/Users/Aditya\ Kumar/Downloads/MiniProject/MiniProject;
#     echo "=== Installing Grafana ===";
#     ansible-playbook -i "${aws_instance.web_server[0].public_ip}," --user ubuntu --private-key ~/.ssh/id_rsa -v grafana_playbook.yml;
#     echo "=== Installing Prometheus ===";
#     ansible-playbook -i "${aws_instance.web_server[0].public_ip}," --user ubuntu --private-key ~/.ssh/id_rsa -v prometheus.yml;
#     ' | tr -d '\r' | bash
#     EOT



