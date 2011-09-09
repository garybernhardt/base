#!/bin/bash

set -e

(rvm use ree@base && rspec spec)
(rvm use ruby-1.9.2-p180@base && rspec spec)
