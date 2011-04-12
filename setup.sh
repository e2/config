#!/bin/sh
# {{{ Functions
get_ruby()
{
  if [ ! -d "~/.rvm" ]; then
    bash -c '"bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)"'
    rvm install 1.9.2-head
    rvm use --default 1.9.2-head
    rvm use 1.9.2-head
  fi
}

get_rake()
{
  get_ruby
}

setup_latest_dotfiles()
{
  if [ ! -d "${dotfiles}" ]; then
    cd "${workspace}"
    git clone ${DOTFILES_URL} "${DOTFILES_DIR}"
  else
    cd "${dotfiles}"
    git pull
  fi
  # generate files
  get_rake
  rake
  cd -
}

restore_dotfiles()
{
  # Restore config files
  DST_PREFIX="${dotfiles}/${ROUTE_PREFIX}"
  check "${DST_PREFIX}" "${HOME}/.zshenv"
  check "${DST_PREFIX}" "${HOME}/.zshrc"
  check "${DST_PREFIX}" "${HOME}/.zsh"
  check "${DST_PREFIX}" "${HOME}/.vimrc"
  check "${DST_PREFIX}" "${HOME}/.gitconfig"
}

#}}}

# URL to your dotfiles repo
DOTFILES_URL=https://github.com/e2/my_dotfiles.git

# Name of directory with dotfiles
DOTFILES_DIR=my_dotfiles

# Prefix for dotfiles, e.g "dot_" means
# there is a file "dot_.vimrc"
ROUTE_PREFIX=route_

set -eu

. ./dot_route

workspace="$(dirname $0)/.."
dotfiles="${workspace}/${DOTFILES_DIR}"

setup_latest_dotfiles
restore_dotfiles

# vi:fdm=marker:
