data "template_file" "bootstrap_node_init" {
  count           =  "${lookup(var.node_count, "bootstrap")}"
  template  = "${file("cloud-init/hadoopnodeprep.yml")}"
  vars  {
    tf_hostname = "${var.project}-${var.environment}-bootstrap"
  }
}


resource "aws_instance" "bootstrap_node" {

  associate_public_ip_address = true
  count           =  "${lookup(var.node_count, "bootstrap")}"
  ami             =  "${var.ami}"
  instance_type   =  "t2.nano"
  key_name        =  "${lookup(var.ssh_key, "on_aws")}"
  instance_type   =  "${var.instance_type}"
  security_groups =  ["${aws_security_group.sg_cdh.id}"]

  subnet_id       =  "${element(aws_subnet.public_subnets.*.id,    (count.index + 1)%3)}"
  user_data       =  "${element(data.template_file.bootstrap_node_init.*.rendered, count.index)}"


  tags {
    Name = "${var.project}-${var.environment}-bootstrap"
    Environment = "${var.environment}"
    Project = "${var.project}"
    Tier = "${var.project}-${var.environment}-bootstrap"
   }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${lookup(var.ssh_key, "rootdir")}/.ssh/${var.local_key_file}"
  }


}
