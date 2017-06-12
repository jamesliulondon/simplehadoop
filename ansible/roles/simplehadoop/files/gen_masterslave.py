#!/usr/local/bin/python

import os
import sys
import io
import json
import getopt

terraform_state_file="../../../../terraform/terraform.tfstate"
master_patterns=["master"]
slave_patterns=["slave","node","data"]

with open(terraform_state_file) as tf:
    data = tf.read()

data_json = json.loads(data)

master_list = set()
slave_list = set()


def main(argv):
    type_of_output=''

    try:
      opts, args = getopt.getopt(argv,"t:",[type_of_output])
    except getopt.GetoptError:
        print 'test.py -i <inputfile> -o <outputfile>'
        sys.exit(2)

    for stacks in data_json['modules'][0]['resources']:
        try:
            name=([data_json['modules'][0]['resources'][stacks]['primary']['attributes']['tags.Name']])
            dummy_test_ec2=([data_json['modules'][0]['resources'][stacks]['primary']['attributes']['key_name']])

            if any(master_pattern in ''.join(name) for master_pattern in master_patterns):
                master_list.update([''.join(name) + "\n"])

            if any(slave_pattern in ''.join(name) for slave_pattern in slave_patterns):

                slave_list.update([''.join(name) + "\n"])
        except:
            pass

    for opt, arg in opts:
        if opt == '-t' and arg in ("master","masters"):
            print ''.join(list(master_list))
        if opt == '-t' and arg in ("slave","slaves"):
            print ''.join(list(slave_list))



if __name__ == "__main__":
   main(sys.argv[1:])
