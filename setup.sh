#!/bin/sh

# URL to your dotfiles repo
DOTFILES_URL=https://github.com/e2/my_dotfiles.git

# Name of directory with dotfiles
DOTFILES_DIR=my_dotfiles

# Prefix for dotfiles, e.g "dot_" means
# there is a file "dot_.vimrc"
ROUTE_PREFIX=route_

set -eu

# make sure we are at home

. ./dot_route

# Download/update repo
workspace="$(dirname $0)/.."
dotfiles="${workspace}/${DOTFILES_DIR}"

if [ ! -d "${dotfiles}" ]; then
  cd "${workspace}"
  git clone ${DOTFILES_URL} "${DOTFILES_DIR}"
else
  cd "${dotfiles}"
  git pull
fi
# generate files
rake
cd -

# Restore config files
DST_PREFIX="${dotfiles}/${ROUTE_PREFIX}"
check "${DST_PREFIX}" "${HOME}/.zshenv"
check "${DST_PREFIX}" "${HOME}/.zshrc"
check "${DST_PREFIX}" "${HOME}/.zsh"
check "${DST_PREFIX}" "${HOME}/.vimrc"
check "${DST_PREFIX}" "${HOME}/.gitconfig"

# vi:fdm=marker:
