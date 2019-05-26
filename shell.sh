#!/bin/bash

test () {

    npm init -y

    local org_alias=$1
    local tmp=$(mktemp)
    sfdx force:config:set defaultusername=$org_alias
    jq '.scripts["test:apex"]="sfdx force:apex:test:run --codecoverage --resultformat human --wait 10"' package.json > $tmp
    mv $tmp package.json

}

test 'test-5ddsuc7ztawk@example.com'

npm run test:apex