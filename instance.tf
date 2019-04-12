resource "aws_key_pair" "keypair" {
  key_name = "keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqlNUMZQc+L7Tw3SXRbv78a6jgvCRGo4jwjaxUXyPgdn1dSY5M/bKj68W9sF2MmiM3VlFk0SEsauBxdiR194WV5vjRsTiMTy4VfyqJFERxEywcdDusboOrWRSOqmLQqzmx5OQGqL+jHBXwnNN23N1w5ITK886Us7WQ95o9mBDfJbSn4RGO+vTIbYJNYzCPYtqLxaiYD2pKY2Dmzeu69bnJv4oaACbt83JIq6uoYP1ya7xNy3Jbep1C8sMwAGWJuB5KA5pUg70FFmos7dNjGxYbKCC2bkRMXMutq1F+AaJ4cv8flQ2cfJs767SzmkKOrJMYajusQOYzUMa/MUf6egsp root@INNOA7LP01993"
}

resource "aws_instance" "basware" {
  ami = "ami-0a574895390037a62"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.keypair.key_name}"
  
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "10"
    volume_type = "standard"
    delete_on_termination = "true"
    encrypted = "true"
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_size = "10"
    volume_type = "standard"
    delete_on_termination = "true"
    encrypted = "true"
  }
  
  user_data = "${file("user-data.sh")}"

  tags {
      Name = "basware" 
 }
}

