# Provider Configuration for AWS
provider "aws" {
region = "ap-southeast-2"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami = "ami-04481c741a0311bbb"
  instance_type = "t2.micro"
  key_name = "ansible-key"
  vpc_security_group_ids = [ "sg-0dabaefc197fd5c4d" ]

  tags {
    Name = "helloworld"
  }

# Helloworld Appication code
  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      private_key = "${file("/Users/szhou/Choice/key/ansible-key.pem")}"
    }
    inline = [
      "sudo curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -",
      "sudo yum install -y nodejs",
      "sudo wget https://raw.githubusercontent.com/yogeshraheja/Effective-DevOps-with-AWS/master/Chapter02/helloworld.js -O /home/ec2-user/helloworld.js",
      "sudo wget https://raw.githubusercontent.com/szhouchoice/EffectiveDevOpsTerraform/master/helloworld.service -O /lib/systemd/system/helloworld.service",
      "sudo systemctl start helloworld",
    ]
  }
}
