#!/bin/bash
cd ../infrastructure || exit 1
terraform apply --destroy
