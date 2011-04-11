#!/bin/sh

set -eu

# make sure we are at home

. ./dot_route

workspace="${HOME}/workspace"
mkdir -p "${workspace}"

dotfiles="${workspace}/my_dotfiles"
if [ ! -d "${dotfiles}" ]; then
  cd "${workspace}"
  git clone https://github.com/e2/my_dotfiles.git
else
  cd "${dotfiles}"
  git pull
fi
cd -

DST_PREFIX="${dotfiles}/route_"
check "${DST_PREFIX}" "${HOME}/.zshenv"
check "${DST_PREFIX}" "${HOME}/.zshrc"
check "${DST_PREFIX}" "${HOME}/.vimrc"

# vi:fdm=marker:
