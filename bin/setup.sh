#!/bin/bash

PACKAGE_NAME="gitlabtest"
recordcount=`sfdx force:data:soql:query -t -u PROD --json -q "Select Count() From Package2 Where Name = '$PACKAGE_NAME'" | jq .result.size -r`
if [ $recordcount -le 0 ]; then
    echo "ERROR: No package found by the name $PACKAGE_NAME"
    return $(( $recordcount <= 0 ))
else
    package_id=`sfdx force:data:soql:query -t -u PROD --json -q "Select Id From Package2 Where Name = '$PACKAGE_NAME'" | jq .result.records[0].Id -r`
fi

echo $package_id

sfdx force:package:version:create -a beta -p gitlabtest -x -w 10

