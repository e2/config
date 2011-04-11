#!/bin/sh
here=$(dirname $0)
apt-get install $(cat "${here}/apt-list.txt" )
