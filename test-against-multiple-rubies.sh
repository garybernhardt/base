#!/bin/bash

set -e

rspec_versions="
    $HOME/.rvm/gems/ree-1.8.7-2011.03@base/bin/rspec
    $HOME/.rvm/gems/ruby-1.9.2-p180@base/bin/rspec
    "
for rspec_path in $rspec_versions; do
    echo "Running specs with ${rspec_path}"
    echo
    $rspec_path spec
done

