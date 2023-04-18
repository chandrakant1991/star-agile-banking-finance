resource "aws_instance" "test-server" {
  ami           = "ami-07d3a50bd29811cd1" 
  instance_type = "t2.micro" 
  key_name = "manu"
  vpc_security_group_ids= ["sg-0e5fd0e80c68fc9cb"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./manu.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
		}
  provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/bankingproject/deployneeds/bankingplaybook.yml"
  } 
}
