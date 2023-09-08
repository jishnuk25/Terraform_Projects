resource "aws_key_pair" "terra-key" {
  key_name = "terrakey"
  public_key = file("terrakey.pub") //reads the contents of the file
}
resource "aws_instance" "terra-instance" {
  ami = var.AMIS[var.REGION]
  instance_type = "t2.micro"
  availability_zone = var.ZONE1
  key_name = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = ["sg-"]
  tags = {
    Name = "Terra-Instance"
    Project = "Terra"
  }
  provisioner "file" {
    source = "web.sh"
    destination = "/tmp/web.sh"
  }
  provisioner "remote-exec" {
    inline = [ 
        "chmod u+x /tmp/web.sh",
        "sudo /tmp/web.sh"
     ]
  }
  connection {
    user = var.USER
    private_key = file("terrakey")
    host = self.public_ip
  }
}