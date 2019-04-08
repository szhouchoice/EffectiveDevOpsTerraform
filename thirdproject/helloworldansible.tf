# Provider Configuration for AWS
provider "aws" {
  region = "ap-southeast-2"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami = "ami-04481c741a0311bbb"
  instance_type = "t2.micro"
  key_name = "ansible-key"
  vpc_security_group_ids = ["sg-0dabaefc197fd5c4d"]

  tags {
    Name = "helloworld"
  }

# Provisioner for applying Ansible playbook
  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      private_key = "${file("/Users/szhou/Choice/key/ansible-key.pem")}"
    }
    inline = [
      "sudo curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -",
      "sudo yum install -y nodejs",
      "sudo yum install -y git",
      "sudo amazon-linux-extras install -y ansible2=latest",
    ]
  }
  
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' > ./myinventory",
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i myinventory --private-key=/Users/szhou/Choice/key/ansible-key.pem helloworld.yml",
  }
}

# IP address of newly created EC2 instance
#output "myserver" {
#  vaule = "${aws_instance.myserver.public_ip}"
#} 
