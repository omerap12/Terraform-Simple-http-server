resource "aws_instance" "instance" {
  count             = var.instances_number
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.main-network-interface.id
  }
  user_data = file("./userdata.sh")
  tags = {
    Name = "webserver"
  }
}