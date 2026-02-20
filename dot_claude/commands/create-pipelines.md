# Create Azure DevOps Pipelines

You are helping the user create Azure DevOps YAML pipelines using the `az pipelines` CLI.

## Step 1: Prerequisites Check & Find YAML Files (in parallel)

Run these in parallel to save time:

### Prerequisites
```bash
az version
az extension show --name azure-devops 2>/dev/null || az extension add --name azure-devops
az account show
```
If not logged in, instruct the user to run `az login` and `az devops configure --defaults organization=URL project=NAME`.

### Find YAML Files
Search for `*.yml` / `*.yaml` in common locations (`azdo/`, `pipelines/`, `.azuredevops/`, `build/`, or the repo root). **Exclude** `node_modules/`, `.github/`, and `test/` directories. Also exclude files that are clearly not pipelines (e.g. `.eslintrc.yml`, `.travis.yml`, `.prettierrc.yaml`).

When presenting results, flag files with "template" in the name as likely templates that don't need their own pipeline.

### Detect Repo Type
Run `git remote get-url origin` to determine if the repo is hosted on GitHub or Azure Repos:
- If the URL contains `github.com` → repo type is `github`
- Otherwise → repo type is `tfsgit` (Azure Repos)

## Step 2: Gather Context

**Ask the user** to confirm or provide:
- Which YAML files should have pipelines created (templates usually excluded)
- The Azure DevOps **organization URL** — default to `https://dev.azure.com/iQmetrix`
- The Azure DevOps **project name** — default to `Ready to Pay`
- The **folder path** in the Pipelines UI (e.g. `Lambdas\MenuCopier`)
- The **pipeline display names** — suggest sensible names derived from the YAML filenames, but let the user override

**Infer automatically** (don't ask unless ambiguous):
- **Default branch**: read from `git branch --show-current` or `git symbolic-ref refs/remotes/origin/HEAD`
- **Repository name**: parse from `git remote get-url origin`

### If repo is on GitHub
First try the **ReadyPay** service connection (`ebeac5c8-b2a0-407b-8d1e-26bfd362459c`). If pipeline creation fails with a permissions error, fall back to listing all available GitHub service connections and ask the user to pick one:
```bash
az devops service-endpoint list --organization ORG_URL --project "PROJECT" --query "[?type=='github']" --output table
```
The selected connection's **ID** is needed for `--service-connection`.

### If repo is on Azure Repos
Run `az repos list --organization ORG_URL --project "PROJECT" --output table` to confirm the repository name. No service connection is needed.

## Step 3: Create the Pipelines

First, ensure the folder exists (ignore "already exists" errors):
```bash
az pipelines folder create --path "FOLDER\PATH" --organization ORG_URL --project "PROJECT" 2>&1 || true
```

For each YAML file the user confirmed, run:

### GitHub repos
```bash
az pipelines create \
  --name "PIPELINE_NAME" \
  --repository "OWNER/REPO" \
  --repository-type github \
  --service-connection "SERVICE_CONNECTION_ID" \
  --branch BRANCH \
  --yml-path PATH_TO_YML_IN_REPO \
  --folder-path "FOLDER\PATH" \
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
  --folder-path "FOLDER\PATH" \
  --skip-first-run true \
  --organization ORG_URL \
  --project "PROJECT"
```

Notes:
- Use `--skip-first-run true` so pipelines don't trigger immediately.
- The `--yml-path` is **relative to the repo root** (e.g. `azdo/deploy-dev.yml`).
- Create multiple pipelines in parallel when possible.

## Step 4: Verify

1. Run `az pipelines list --folder-path "FOLDER\PATH" --organization ORG_URL --project "PROJECT" --output table` to confirm everything was created.
2. Summarize what was created in a table: pipeline name, YAML file, folder, ID.
3. Remind the user that `--skip-first-run` was used, so they need to trigger runs manually or push a commit.

## Arguments

$ARGUMENTS — If provided, treat these as additional context (e.g. repo name, folder path, or specific YAML files to target).
