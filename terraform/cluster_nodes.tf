data "template_file" "cluster_node_init" {
  count           =  "${lookup(var.node_count, "cluster")}"
  template  = "${file("cloud-init/hadoopnodeprep.yml")}"
  vars  {
    tf_hostname = "${var.project}-${var.environment}-node${count.index}"
  }
}

resource "aws_instance" "cluster" {

  associate_public_ip_address = true
  count           =  "${lookup(var.node_count, "cluster")}"
  ami             =  "${var.ami}"
  instance_type   =  "t2.nano"
  key_name        =  "${lookup(var.ssh_key, "on_aws")}"
  instance_type   =  "${var.instance_type}"
  security_groups =  ["${aws_security_group.sg_cdh.id}"]

  subnet_id       =  "${element(aws_subnet.public_subnets.*.id,    (count.index + 1)%3)}"
  user_data       =  "${element(data.template_file.cluster_node_init.*.rendered, count.index)}"


  tags {
    Name = "${var.project}-${var.environment}-node${count.index}"
    Environment = "${var.environment}"
    Project = "${var.project}"
   }


  #provisioner "file" {
  #  source = "templates/cloudera-cm5.repo"
  #  destination = "/tmp/cloudera-cm5.repo"
    connection {
      type = "ssh"
      user = "root"
      private_key = "${lookup(var.ssh_key, "rootdir")}/.ssh/${var.local_key_file}"
    }
  #}


}
