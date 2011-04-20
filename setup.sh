#!/bin/bash
# {{{ Functions
get_ruby()
{
  if [ ! -d "${HOME}/.rvm" ]; then
    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
  fi

  source "${HOME}"/.rvm/scripts/rvm

  ruby_version=ruby-1.9.2-head
  if ! rvm list | grep $ruby_version; then

    # Base ruby is required to build 1.9.2
    base_ruby=ruby-1.8.7
    if ! rvm list | grep $base_ruby; then
      rvm install $base_ruby -C --disable-install-doc
    fi
    rvm use $base_ruby

    rvm install $ruby_version -C --disable-install-doc
  fi

  rvm use --default $ruby_version
  rvm use $ruby_version
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
  check "${DST_PREFIX}" "${HOME}/.gitignore"
  check "${DST_PREFIX}" "${HOME}/.uncrustify.cfg"
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

  mkdir -p "autoload"

  if [ ! -h autoload/pathogen.vim ]; then
    ln -s ../vim-pathogen/autoload/pathogen.vim autoload/
  fi

  mkdir -p "bundle"
  pushd bundle
  [ -e vim-fugitive ] || git clone git://github.com/tpope/vim-fugitive.git
  [ -e vim-endwise ] || git clone git://github.com/tpope/vim-endwise.git
  [ -e vim-rails ] || git clone git://github.com/tpope/vim-rails.git
  [ -e vim-ruby ] || git clone git://github.com/vim-ruby/vim-ruby.git
  [ -e vim-surround ] || git clone git://github.com/tpope/vim-surround.git
  [ -e nerdcommenter ] || git clone git://github.com/scrooloose/nerdcommenter.git
  [ -e vim-cucumber ] || git clone git://github.com/tpope/vim-cucumber.git
  [ -e vim-unimpaired ] || git clone git://github.com/tpope/vim-unimpaired.git
  [ -e vim-haml ] || git clone git://github.com/tpope/vim-haml.git
  [ -e vim-vimoutliner ] || git clone git://github.com/e2/vim-vimoutliner.git
  popd
  [ -d plugin ] || mkdir -p plugin

  [ -e plugin/a.vim ] || wget -c -O plugin/a.vim 'http://www.vim.org/scripts/download_script.php?src_id=7218'

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
