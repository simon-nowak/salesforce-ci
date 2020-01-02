.PHONY: shellcheck


# Run shellcheck on the pure shell parts of the GitLab CI configuration - requires yq, shellcheck, bash, and sed

shellcheck:
	cat Salesforce.gitlab-ci.yml | yq -r .\".sfdx_helpers\" | sed "s/\\n/\'$'\n''/g" | shellcheck - --shell bash
