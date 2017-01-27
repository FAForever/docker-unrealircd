#!/bin/bash

pgrep -f services 1> /dev/null

exit $?
