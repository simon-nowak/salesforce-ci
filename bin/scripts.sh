#!/bin/bash

function setuporg() {
    sfdx force:source:push
}

function runtests() {
    sfdx force:apex:test:run -c -d ~/junit -r junit --wait 5
}