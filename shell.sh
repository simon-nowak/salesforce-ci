#!/bin/bash

test() {

    local output=""
    if [ -n "$output" ]; then
      echo 'found'
    else
      echo 'empty'
    fi

}

x=$(test foo bar)
echo result=$x