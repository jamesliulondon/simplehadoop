output "bootstrap" {
  #value = ["Nuke!"]
  #value = ["${format("%s %s %s %s", "${lookup(var.sample_hostnames, concat("name", index))}","${aws_instance.cdh.*.public_dns}", "${aws_instance.cdh.*.public_ip}","${aws_instance.cdh.*.private_ip}")}"]
  value = ["${format("%s %s %s", "${aws_instance.bootstrap_node.*.public_dns}", "${aws_instance.bootstrap_node.*.public_ip}", "${aws_instance.bootstrap_node.*.private_ip}")}"]
}

output "master" {
  value = ["${format("%s %s %s", "${aws_instance.master.*.public_dns}", "${aws_instance.master.*.public_ip}", "${aws_instance.master.*.private_ip}")}"]
}
output "cluster" {
  value = ["${format("%s %s %s", "${aws_instance.cluster.*.public_dns}", "${aws_instance.cluster.*.public_ip}", "${aws_instance.cluster.*.private_ip}")}"]
}
output "addresses" {
  value = "${var.node_count}"
}
