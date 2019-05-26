#!/bin/bash

test() {

    local debug=$(echo "[check_has_jest_tests]" | tee /dev/stderr)
    local hasJestTests=false
    for pkgDir in $(jq -r '.packageDirectories[].path' < sfdx-project.json | tee /dev/stderr)
    do
      if [ -f $pkgDir ]; then
        local fileCnt=$(find $pkgDir -type f -path "**/__tests__/*.test.js" | tee /dev/stderr | wc -l);
        if [ $fileCnt -gt 0 ]; then
          hasJestTests=true
        fi
      fi
    done
    echo $hasJestTests
}

x=$(test)
echo x=$x