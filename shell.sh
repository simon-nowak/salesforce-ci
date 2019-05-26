#!/bin/bash

check_has_jest_tests () {

  local hasJestTests=false

  for pkgDir in $(jq -r '.packageDirectories[].path' < sfdx-project.json)
  do
    if [ -f $pkgDir ]; then
      local fileCnt=$(find $pkgDir -type f -name "*.test.js" | wc -l);
      if [ $fileCnt -gt 0 ]; then
        hasJestTests=true
      fi
    fi
  done

  echo $hasJestTests

}

check=$(check_has_jest_tests)

if [ $check ]; then
  echo hooray!
else
  echo boo
fi