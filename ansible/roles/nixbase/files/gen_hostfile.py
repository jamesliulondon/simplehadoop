#!/usr/local/bin/python

import os
import sys
import io
import json


with open('../../../../terraform/terraform.tfstate') as tf:
    data = tf.read()

data_json = json.loads(data)

hostlist = set()
for stacks in data_json['modules'][0]['resources']:
    try:
        ip=([data_json['modules'][0]['resources'][stacks]['primary']['attributes']['private_ip']])
        name=([data_json['modules'][0]['resources'][stacks]['primary']['attributes']['tags.Name']])

        hostlist.update([''.join(ip) + '        ' + ''.join(name) + "\n"])

        #another.update([[data_json['modules'][0]['resources'][stacks]['primary']['attributes']['tags.Name']] => [data_json['modules'][0]['resources'][stacks]['primary']['attributes']['private_ip']]])
    except:
        pass

ips_string = "\n".join(list(hostlist))
print ''.join(list(hostlist))
#print list(another)
