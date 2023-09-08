#!/bin/bash
lpadmin -p test-script -v socket://10.44.12.250:9100 -m drv:///sample.drv/generic.ppd -o printer-is-shared=true -D "Test lpadmin" -E -L "Test Location"
lpadmin -p MX123 -v socket://10.44.12.250:9100 -m drv:///sample.drv/generic.ppd -o printer-is-shared=true -D "Test lpadmin" -E -L "Test Location"
