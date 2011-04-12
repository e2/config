#!/bin/bash
# {{{ Functions
get_ruby()
{
  RUBY_VERSION=ruby-1.9.2-head

  if [ ! -d "${HOME}/.rvm" ]; then
    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
  fi

  source "${HOME}"/.rvm/scripts/rvm

  if ! rvm list | grep $RUBY_VERSION; then
    rvm install $RUBY_VERSION
  fi

  rvm use --default $RUBY_VERSION
  rvm use $RUBY_VERSION
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

setup_vim()
{
  url=https://github.com/tpope/vim-pathogen

  vim_dir="${HOME}/.vim"
  if [ ! -e "${vim_dir}" ]; then
    mkdir -p "${vim_dir}"
  fi

  pushd "${vim_dir}"

  if [ ! -e "vim-pathogen/.git" ]; then
    git clone $url
  fi

  mkdir -p "bundle"
  mkdir -p "autoload"

  if [ ! -h autoload/pathogen.vim ]; then
    ln -s ../vim-pathogen/autoload/pathogen.vim autoload/
  fi

  popd
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

setup_vim

# vi:fdm=marker:
