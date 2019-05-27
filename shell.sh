#!/bin/bash

test() {

    local username="DevHub"
    local object="Account"
    local name="CD656092"
    local cmd="sfdx force:data:record:get --sobjecttype $object --targetusername $username --where "'"AccountNumber='$name'"'" --json" && (echo $cmd >&2)
    local output=$($cmd) && (echo $output | jq >&2)
    echo $(jq -r '.result.Id' <<< $output)
}

x=$(test foo bar)
echo result=$x