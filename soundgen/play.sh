#!/bin/bash
ruby soundgen.rb | play -t raw -b 32 -r 44100 -c 1 -e floating-point --endian little -
