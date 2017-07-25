data "template_file" "cluster_node_init" {
  count           =  "${lookup(var.node_count, "cluster")}"
  template  = "${file("cloud-init/hadoopnodeprep.yml")}"
  vars  {
    tf_hostname = "${var.project}-${var.environment}-node${count.index}"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  count           =  "${lookup(var.node_count, "cluster")}"
  device_name = "/dev/sdh"
  volume_id   = "${element(aws_ebs_volume.ebs_cluster.*.id,    (count.index)%3)}"
  instance_id = "${element(aws_instance.cluster.*.id,          (count.index)%3)}"
}

resource "aws_instance" "cluster" {

  associate_public_ip_address = true
  count           =  "${lookup(var.node_count, "cluster")}"
  ami             =  "${var.ami}"
  key_name        =  "${lookup(var.ssh_key, "on_aws")}"
  instance_type   =  "${var.instance_type}"
  security_groups =  ["${aws_security_group.sg_cdh.id}"]

  subnet_id       =  "${element(aws_subnet.public_subnets.*.id,    (count.index)%3)}"
  user_data       =  "${element(data.template_file.cluster_node_init.*.rendered, count.index)}"

  tags {
    Name = "${var.project}-${var.environment}-node${count.index}"
    Environment = "${var.environment}"
    Project = "${var.project}"
    Tier = "${var.project}-${var.environment}-node"
   }

   root_block_device {
     volume_size = "${var.rbd_size}"
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


resource "aws_ebs_volume" "ebs_cluster" {
  count           =  "${lookup(var.node_count, "cluster")}"
  availability_zone = "${lookup(var.availability_zones, "az${(count.index + 1)%3}")}"
  size              = 40
}
