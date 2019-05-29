# GitLab CI/CD for Salesforce

This project contains a fully configured CI pipeline that works with Salesforce SFDX projects.
The CI configuration file (the yml) is called by the yml located in sfdx-project-template

The yml is configured to run tests on your Salesforce app every time you make a commit.
There are 6 stages to this Pipeline:

# What it does

- **Preliminary Testing**: For unit tests that can run in the context of a runner, without deployment to a scratch org. By default, this stage runs Jest tests for Lightning Web Components, if they exist.
- **Create Scratch Org**: Checks that you're allowed to create a scratch org, then creates it and pushes the app to it. Note there is also a "delete scratch org" job which can be run manually to remove and clean up leftover scratch orgs
- **Test Scratch Org**: Runs tests on the scratch org, such as Apex tests. At this point your team can conduct manual testing in the scratch org.
- **Package**: Create the package for deployment to sandbox and production orgs. Only runs in the master branch.
- **Staging**: Deploy to a pre-production org, such as a sandbox. This is a manual job which must be triggered by pressing the button, and only runs in the master branch.
- **Production**: Promote the app and deploy to production. This is a manual job which must be triggered by pressing the button, and only runs in the master branch.

# Setting up your project

- Your `sfdx-project.json` file must be complete, including project IDs, in order for package version creation to work. This is created when you run the package create command from the CLI in an SFDX project
- Devhub must be enabled on the devhub org in order to use scratch orgs
- The yml is set to create a scratch org and run your apex tests on every commit, you can turn this off by setting `DEPLOY_SCRATCH_ON_EVERY_COMMIT` to false (see below)


### Environment variables

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
