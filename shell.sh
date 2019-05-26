#!/bin/bash

test () {

    export local dev_hub_alias=$1
    export local package_name=$2

    local package_id=$(sfdx force:package:list --targetdevhubusername "$dev_hub_alias" --json | jq -r '.result[] | select(.Name == env.package_name) | .Id')

    echo $package_id

}

test DevHub DreamHouse
