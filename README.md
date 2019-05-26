### GitLab CI/CD for Salesforce ###

This project contains a fully configured CI pipeline that works with Salesforce SFDX projects.
The CI configuration file (the yml) is called by the yml located in sfdx-project-template 

This project also holds the test application and workspace for the GitLab/Salesforce CI/CD template.


### About the CI Pipeline ###

The yml is configured to run tests on your Salesforce app every time you make a commit. 
There are 5 stages to this Pipeline

# what it does

 - deploy-scratch: Automated
 Creates a scratch org, pushes your app.
 Creates scratch test environment for you to do manual testing in

 - test-scratch: Automated
 Runs local tests on LWC and Apex tests in the org
 At this point your team should conduct manual testing in the scratch org

 - delete-scratch: Manual
 Deletes the scratch org created for testing
 The step is manual because it is best practice to conduct manual testing in the generated test environment (the scratch org) in the test-scratch stage

 - deploy-sandbox: Manual
 Creates a new package version of your app
 Installs the new package version into your Sandbox
 This step is manual because you may not want to create a new package version after the tests have run or the manual review of the scratch org in the previous steps

 - test-sandbox: Automated
 Runs all tests

 - deploy-production: Manual
 Deploys the new package version to your production org
 This step is manual because you may have requirements around when and how often you deploy to your production org

# Configuration options

- The yml is set to create a scratch org and run your apex tests on every commit, you can turn this off by setting `DEPLOY_SCRATCH_ON_EVERY_COMMIT` to false (see below)

If you are using Merge Requests (which is recommended) you can add the following to a commit message:

- `[deploy scratch]` - Deploys to scratch org on the commit even if $DEPLOY_SCRATCH_ON_EVERY_COMMIT is falseish
- `[skip deploy scratch]` - Skips the scratch deployment on the commit even if $DEPLOY_SCRATCH_ON_EVERY_COMMIT is trueish


### Setup ###

To use GitLab CI, you need to authenticate the GitLab project to your orgs in Salesforce. Here are the steps:

1. Make sure you have the SFDX CLI installed on your local machine and have authenticated into your orgs using the web authentication flow
2. Use the `sfdx force:org:display --verbose` command to get the "Sfdx Auth Url" for your various orgs. The URL you're looking for starts with `force://`
3. Populate the variables under Settings -> CI/CD -> Variables in your project in GitLab

Here are the Auth URL variables to set.

- `DEVHUB_AUTH_URL`
- `SANDBOX_AUTH_URL`
- `PRODUCTION_AUTH_URL`

Here are some other variables that are optional:

- `DEPLOY_SCRATCH_ON_EVERY_COMMIT`: "true" to deploy a scratch org on every commit in an MR, otherwise it won't.
- `PACKAGE_NAME`: Optional. Must match one of the `package` entries in `sfdx-project.json`. If not present, then we'll pull the default package from `sfdx-project.json`.

Optionally, disable entire jobs with the following variables:

- `TEST_DISABLED`
- `SCRATCH_DISABLED`
- `SANDBOX_DISABLED`
- `PRODUCTION_DISABLED`

# notes

- Your `sfdx-project.json` file must be complete, including project IDs, in order for package version creation to work. This is created when you run the package create command from the CLI in an SFDX project
- Devhub must be enabled on the org in order to use scratch orgs
- If you want to add more steps to the yml, you can copy the file and add it to your GitLab repository with the extension .gitlab-ci.yml
