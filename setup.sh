#!/bin/sh

set -eu

# make sure we are at home

. ./dot_route

workspace="${HOME}/workspace"
mkdir -p "${workspace}"

dotfiles="${workspace}/dotfiles"
if [ ! -d "${dotfiles}" ]; then
  cd "${workspace}"
  git clone github.com:e2/dotfiles
  cd -
fi


DST_PREFIX="${dotfiles}/route_"
check "${DST_PREFIX}" "${HOME}/.zshenv"
check "${DST_PREFIX}" "${HOME}/.zshrc"
check "${DST_PREFIX}" "${HOME}/.vimrc"

# vi:fdm=marker:
