# Create Azure DevOps Pipelines

You are helping the user create Azure DevOps YAML pipelines using the `az pipelines` CLI.

## Gather Context

1. **Find the YAML pipeline files** in this repo. Search for files matching patterns like `*.yml` or `*.yaml` in common locations (`pipelines/`, `.azuredevops/`, `build/`, or the repo root). Present the list to the user.

2. **Ask the user** to confirm or provide:
   - Which YAML files should have pipelines created for them
   - The Azure DevOps **organization URL** (e.g. `https://dev.azure.com/ORG`)
   - The Azure DevOps **project name**
   - The **repository name** in Azure DevOps (run `az repos list --output table` if unsure)
   - The **default branch** (e.g. `main`, `master`, `develop`)
   - The **folder path** in the Pipelines UI where these should live (e.g. `Lambdas\MenuCopier`)
   - The **pipeline display names** — suggest sensible names derived from the YAML filenames, but let the user override

## Prerequisites Check

Before creating pipelines, verify the CLI is ready:

```bash
# Check az CLI is installed
az version

# Check azure-devops extension
az extension show --name azure-devops 2>/dev/null || az extension add --name azure-devops

# Check login status
az account show
```

If not logged in, instruct the user to run `az login` and `az devops configure --defaults organization=URL project=NAME`.

## Create the Pipelines

For each YAML file the user confirmed, run:

```bash
az pipelines create \
  --name "PIPELINE_NAME" \
  --repository REPO_NAME \
  --repository-type tfsgit \
  --branch BRANCH \
  --yml-path PATH_TO_YML_IN_REPO \
  --folder-path "FOLDER\PATH" \
  --skip-first-run true
```

Notes:
- Use `--repository-type tfsgit` for Azure Repos. Use `github` if the repo is on GitHub.
- Use `--skip-first-run true` so pipelines don't trigger immediately.
- If the folder doesn't exist yet, create it first: `az pipelines folder create --path "FOLDER\PATH"`
- The `--yml-path` is **relative to the repo root** (e.g. `pipelines/deploy-dev.yml`).

## After Creation

1. Run `az pipelines list --folder-path "FOLDER\PATH" --output table` to confirm everything was created.
2. Summarize what was created in a table: pipeline name, YAML file, folder.
3. Remind the user that `--skip-first-run` was used, so they need to trigger runs manually or push a commit.

## Arguments

$ARGUMENTS — If provided, treat these as additional context (e.g. repo name, folder path, or specific YAML files to target).
