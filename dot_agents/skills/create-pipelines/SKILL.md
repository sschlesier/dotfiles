---
name: create-pipelines
description: Create Azure DevOps YAML pipelines using the az CLI. Use when the user wants to create or verify Azure DevOps pipelines for one or more YAML files in the current repository. Not for editing pipeline YAML contents themselves unless that is part of preparing files before pipeline creation.
---

# Create Azure DevOps Pipelines

Help the user create Azure DevOps YAML pipelines with `az pipelines`.

Treat any extra prompt text as task context such as repository name, Azure DevOps organization URL, project name, folder path, service connection, branch, pipeline names, or specific YAML files to target.

## Workflow

Follow this sequence:

1. Check prerequisites and scan the repo for candidate YAML files in parallel.
2. Infer repository context where possible.
3. Ask the user to confirm the YAML files and any missing Azure DevOps settings.
4. Create the pipelines.
5. Verify creation and summarize results.

Prefer parallel tool calls when checking prerequisites, scanning files, or creating multiple independent pipelines.

## Step 1: Prerequisites And YAML Discovery

Run these checks:

```bash
az version
az extension show --name azure-devops 2>/dev/null || az extension add --name azure-devops
az account show
```

If Azure CLI auth is missing, instruct the user to run:

```bash
az login
az devops configure --defaults organization=URL project=NAME
```

Search for `*.yml` and `*.yaml` in common pipeline locations:

- `azdo/`
- `pipelines/`
- `.azuredevops/`
- `build/`
- repository root

Exclude:

- `node_modules/`
- `.github/`
- `test/`
- files clearly unrelated to pipelines such as `.eslintrc.yml`, `.travis.yml`, `.prettierrc.yaml`

When presenting candidates, flag files with `template` in the file name as likely reusable templates that usually do not need their own pipeline.

## Step 2: Detect Repository Context

Run:

```bash
git remote get-url origin
```

Interpret the repo type as:

- URL contains `github.com`: `github`
- otherwise: `tfsgit`

Infer automatically unless ambiguous:

- default branch from `git branch --show-current` or `git symbolic-ref refs/remotes/origin/HEAD`
- repository name from `git remote get-url origin`

## Step 3: Gather Missing User Input

Ask the user to confirm or provide:

- which YAML files should get pipelines
- Azure DevOps organization URL, default `https://dev.azure.com/iQmetrix`
- Azure DevOps project name, default `Ready to Pay`
- folder path in the Pipelines UI, for example `Lambdas\MenuCopier`
- pipeline display names, with sensible filename-derived suggestions

Do not ask for values that can be safely inferred.

### GitHub Repositories

Try the `ReadyPay` service connection first:

- `ebeac5c8-b2a0-407b-8d1e-26bfd362459c`

If pipeline creation fails with a permissions error, list available GitHub service connections and ask the user to pick one:

```bash
az devops service-endpoint list --organization ORG_URL --project "PROJECT" --query "[?type=='github']" --output table
```

Use the selected connection ID with `--service-connection`.

### Azure Repos

Confirm the repository name with:

```bash
az repos list --organization ORG_URL --project "PROJECT" --output table
```

No service connection is needed for Azure Repos pipelines.

## Step 4: Create Pipelines

Ensure the destination folder exists first. Ignore already-exists errors:

```bash
az pipelines folder create --path "FOLDER\\PATH" --organization ORG_URL --project "PROJECT" 2>&1 || true
```

For each confirmed YAML file, use a repo-root-relative path for `--yml-path`.

### GitHub

```bash
az pipelines create \
  --name "PIPELINE_NAME" \
  --repository "OWNER/REPO" \
  --repository-type github \
  --service-connection "SERVICE_CONNECTION_ID" \
  --branch BRANCH \
  --yml-path PATH_TO_YML_IN_REPO \
  --folder-path "FOLDER\\PATH" \
  --skip-first-run true \
  --organization ORG_URL \
  --project "PROJECT"
```

### Azure Repos

```bash
az pipelines create \
  --name "PIPELINE_NAME" \
  --repository REPO_NAME \
  --repository-type tfsgit \
  --branch BRANCH \
  --yml-path PATH_TO_YML_IN_REPO \
  --folder-path "FOLDER\\PATH" \
  --skip-first-run true \
  --organization ORG_URL \
  --project "PROJECT"
```

Notes:

- use `--skip-first-run true` so new pipelines do not trigger immediately
- `--yml-path` must be relative to the repo root, for example `azdo/deploy-dev.yml`
- create multiple pipelines in parallel when the commands are independent

## Step 5: Verify

Run:

```bash
az pipelines list --folder-path "FOLDER\\PATH" --organization ORG_URL --project "PROJECT" --output table
```

Then summarize:

- pipeline name
- YAML file
- folder
- pipeline ID

Remind the user that `--skip-first-run` was used, so they must trigger runs manually or push a commit that satisfies the pipeline triggers.

## Output Expectations

When proposing or confirming work, keep the summary concrete:

- detected repo type
- detected branch
- candidate YAML files
- selected YAML files
- Azure DevOps org and project
- destination folder
- pipeline names
- service connection used, if any
- verification result
