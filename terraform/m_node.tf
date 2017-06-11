data "template_file" "master_node_init" {
  count           =  "${lookup(var.node_count, "master")}"
  template  = "${file("cloud-init/hadoopnodeprep.yml")}"
  vars  {
    tf_hostname = "${var.project}-${var.environment}-master${count.index}"
  }
}

resource "aws_instance" "master" {

  associate_public_ip_address = true
  count           =  "${lookup(var.node_count, "master")}"
  ami             =  "${var.ami}"
  instance_type   =  "t2.nano"
  key_name        =  "${lookup(var.ssh_key, "on_aws")}"
  instance_type   =  "${var.instance_type}"
  security_groups =  ["${aws_security_group.sg_cdh.id}"]

  subnet_id       =  "${element(aws_subnet.public_subnets.*.id,    (count.index + 1)%3)}"
  user_data       =  "${element(data.template_file.master_node_init.*.rendered, count.index)}"


  tags {
    Name = "${var.project}-${var.environment}-master${count.index}"
    Environment = "${var.environment}"
    Project = "${var.project}"
    Tier = "${var.project}-${var.environment}-master"
   }



  #provisioner "file" {
  #  source = "templates/training_public_key"
  #  destination = "/tmp/training_public_key"
    connection {
      type = "ssh"
      user = "root"
      private_key = "${lookup(var.ssh_key, "rootdir")}/.ssh/${var.local_key_file}"

    }
  #}


}
