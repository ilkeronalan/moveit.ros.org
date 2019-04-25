#!/bin/bash -eu
# Locally build the Jekyl site for testing on Ubuntu 16.04

have_travis() {
  for arg in "$@"; do
    if [[ "${arg}" == "travis" ]]; then
      return 0
    fi
  done
  return 1
}

if [[ "$0" != "${BASH_SOURCE}" ]]; then
  {
    echo "This file is meant to be executed, not 'source'd:"
    echo
    echo "    ./${BASH_SOURCE}"
  } >&2
  return 1
fi

# Install dependencies
sudo apt-get install ruby ruby-dev build-essential
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
gem install jekyll
gem install bundler -v 1.17.3
bundle install

# Test website using same script as Travis
if have_travis "$@"; then
  ./.travis.sh
fi

# Launch website
echo
echo "-------------------------------------"
echo "-------------------------------------"
echo "Preparing to open http://localhost:4000"
echo "Be sure to refresh auto-opened webpage"
read -p "Press any key to start serving website..."
echo "-------------------------------------"
echo "-------------------------------------"
echo
google-chrome http://localhost:4000

# Start serving website locally
bundle exec jekyll serve
