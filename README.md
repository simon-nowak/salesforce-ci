# GitLab CI/CD for Salesforce

This is a test application and workspace for the GitLab/Salesforce CI/CD template.

To use GitLab CI, set the following environment variables:

- `DEPLOY_SCRATCH_ON_EVERY_COMMIT`: "true" to deploy a scratch org on every commit in an MR, otherwise it won't.
- `PACKAGE_NAME`: Optional. Must match one of the `package` entries in `sfdx-project.json`. If not present, then we'll pull the default package from `sfdx-project.json`.

- `SERVER_KEY_PASSWORD`: This is `Password01` if you followed the instructions provided for generating the server key.
- `SF_USERNAME`: Your username
- `SF_CONSUMER_KEY`: The consumer key for the app, from the UI

Optionally, disable entire jobs with the following variables:

- `TEST_DISABLED`
- `SCRATCH_DISABLED`
- `SANDBOX_DISABLED`
- `PRODUCTION_DISABLED`

### Some notes

- Expects `secure.key.enc` to be at the root, not in an `assets` directory.
- No support for a `JWT` directory within the project - more securely, use `~/.jwt` to keep certificates and the like.
- Your `sfdx-project.json` file must be complete, including project IDs, in order for package version creation to work.

### Intended behavior

- On master commits:
    - Run unit tests
    - Deploy to scratch org
    - Run integration tests
    - Wait for manual approval of scratch org
    - Delete scratch org (need to remember username)
    - Package (does this need to happen previously?)
    - Deploy to staging sandbox
    - Wait for approval on staging sandbox (is this necessary?)
    - Deploy to production org
- On MR commits:
    - Run unit tests
    - If $DEPLOY_SCRATCH_ON_EVERY_COMMIT is trueish (need to find out best practice for this):
        - Deploy to scratch org
        - Run integration tests
        - Wait for manual approval of scratch org
        - Delete scratch org (need to remember username)

Options in commit message (ignored outside of MRs)

- `[deploy scratch]` - Deploys to scratch org on the commit even if $DEPLOY_SCRATCH_ON_EVERY_COMMIT is falseish
- `[skip deploy scratch]` - Skips the scratch deployment on the commit even if $DEPLOY_SCRATCH_ON_EVERY_COMMIT is trueish


### Using GitLab CI with Salesforce

The following instructions assume you are a Salesforce developer with salesforce.com access.

1. Install Salesforce DX. Enable the Dev Hub in your org or sign up for a Dev Hub trial org and install the Salesforce DX CLI. Follow the instructions in the [Salesforce DX Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm?search_text=trial%20hub%20org) or in the [App Development with Salesforce DX](https://trailhead.salesforce.com/modules/sfdx_app_dev) Trailhead module.


### Legacy (Dreamhouse) documentation

1. Create a scratch org and provide it with an alias of your choice (**dh** in the command below):
    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a dh
    ```

1. Push the app to your scratch org:
    ```
    sfdx force:source:push
    ```

1. Assign the **dreamhouse** permission set to the default user:
    ```
    sfdx force:user:permset:assign -n dreamhouse
    ```

1. Open the scratch org:
    ```
    sfdx force:org:open
    ```

1. Select **DreamHouse** in the App Launcher

1. Click the **Data Import** tab and click **Initialize Sample Data**
