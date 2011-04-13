#!/bin/sh

set -e
set -u

install_packages()
{
  here=$(dirname $0)
  apt-get -y install $(cat "${here}/apt-list.txt" )
}

setup_apt()
{
  sources=/etc/apt/sources.list
  universe=/etc/apt/sources.list.d/universe.list
  if ! grep universe "${sources}"; then
    if [ ! -e "${universe}" ]; then
      cat "${sources}" | sed -e 's/\(.*\) main$/\1 universe/g' > "${universe}"
      apt-get update
    fi
  fi
}

#TODO: put this somewhere else?
LOCALE=en_US.utf8 ja_JP.utf8 pl_PL.utf8

setup_locale $LOCALE
setup_apt
install_packages
