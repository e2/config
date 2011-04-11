#!/bin/sh
here=$(dirname $0)
apt-get install $(< "${here}/apt-list.txt")
