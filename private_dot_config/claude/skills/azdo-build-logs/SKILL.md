---
name: azdo-build-logs
description: Inspect an Azure DevOps pipeline build — status, timeline, and per-step logs — using the az CLI. Use whenever asked to check, investigate, or debug an Azure DevOps build/pipeline run by build ID, build number, or pipeline name (e.g. "check build 855354", "why did the release pipeline fail").
allowed-tools: Bash
---

Azure DevOps build inspection with `az` is entirely doable without a browser, but the useful
commands are not the obvious ones (`az pipelines runs tasks list` does not exist — do not try it,
it errors with no output). This skill is the command reference so that doesn't need rediscovering
each time. All Ready repos in `~/src` live in the same ADO org/project unless noted otherwise.

Assume `az login`, the `azure-devops` extension, and default org/project are already set up —
don't check them up front. If that assumption is wrong you'll see it immediately (see the recovery
section below).

## Step 1: Get build metadata from a build ID

```bash
az pipelines build show --id <BUILD_ID> -o json
```

Key fields to pull out: `result` (`succeeded`/`failed`/`partiallySucceeded`), `definition.name` and
`definition.id` (the pipeline), `sourceBranch` (e.g. `refs/tags/v1.1.7+1007`), `queue.name` (agent
pool), `finishTime`. This tells you *which* pipeline ran and whether it's even worth digging
further.

Web link for handing back to a human: `https://dev.azure.com/<org>/<project>/_build/results?buildId=<BUILD_ID>`

## Step 2: Get the timeline to find which step failed

There is no dedicated `az pipelines` subcommand for this — use the generic REST invoker:

```bash
az devops invoke --area build --resource timeline \
  --route-parameters project="Ready to Pay" buildId=<BUILD_ID> \
  --org https://dev.azure.com/iqmetrix -o json > /tmp/timeline_<BUILD_ID>.json
```

(Redirect to a file rather than piping — the payload can be large and you'll want to re-query it.)

Then filter for the failing record(s) and note each one's `log.id`:

```bash
python3 -c "
import json
data = json.load(open('/tmp/timeline_<BUILD_ID>.json'))
for r in data['records']:
    if r.get('result') in ('failed', 'partiallySucceeded'):
        print(r.get('type'), '|', r.get('name'), '| log:', (r.get('log') or {}).get('id'))
"
```

Records have `type` of `Stage`, `Phase`, `Job`, or `Task`. The `Task` record (e.g. "Build dev IPA")
is usually the one with the actual useful log — `Job`/`Phase`/`Stage` failures are just the failure
propagating up and their logs are mostly noise.

## Step 3: Fetch the actual log content for a step

```bash
az devops invoke --area build --resource logs \
  --route-parameters project="Ready to Pay" buildId=<BUILD_ID> logId=<LOG_ID> \
  --org https://dev.azure.com/iqmetrix -o json > /tmp/log<LOG_ID>_<BUILD_ID>.json
```

The response is `{"value": ["<timestamp> <line>", ...]}` — one string per line, not raw text. Print it:

```bash
python3 -c "
import json
for line in json.load(open('/tmp/log<LOG_ID>_<BUILD_ID>.json'))['value']:
    print(line)
"
```

Scan for lines containing `##[error]` or `Error (Xcode)` etc. — the real failure is usually near
the end, right before `##[section]Finishing: <step name>`.

## Recovering from an auth/org/project error

If any command above fails with an auth error, an "extension not found" error, or a complaint about
missing `--org`/`--project` (Step 1's `build show` doesn't pass them explicitly, so it's the one
most likely to surface this), diagnose with:

```bash
az account show                              # confirms az login is active
az extension list -o table | grep devops      # confirms azure-devops extension is installed
az devops configure -l                        # shows configured default org/project, if any
```

If the extension is missing: `az extension add --name azure-devops`.

If defaults aren't set (or you're working in a different Ready repo/project), either set them:
```bash
az devops configure --defaults organization=https://dev.azure.com/iqmetrix project="Ready to Pay"
```
or pass `--org`/`--project` explicitly on every command in this skill. For this org, the known
project is `"Ready to Pay"` at `https://dev.azure.com/iqmetrix` — quote the project name, it has
spaces.

## Other useful lookups

**List all pipeline definitions in the project** (to map a human-readable pipeline name to its
numeric definition ID):
```bash
az pipelines list --org https://dev.azure.com/iqmetrix --project "Ready to Pay" -o json \
  | python3 -c "import json,sys; [print(d['id'], d['name']) for d in json.load(sys.stdin)]"
```

**List recent runs for a specific pipeline** (to find build history / last success):
```bash
az pipelines build list --org https://dev.azure.com/iqmetrix --project "Ready to Pay" \
  --definition-ids <DEFINITION_ID> --top 10 -o json \
  | python3 -c "
import json,sys
for b in json.load(sys.stdin):
    print(b['id'], b['buildNumber'], b['status'], b.get('result'), b['sourceBranch'], b['finishTime'])
"
```
Don't trust an empty result from `--result succeeded` (or any `--result` filter) as proof nothing
succeeded — drop the filter and check manually; some ADO CLI versions return nothing on a filtered
query even when unfiltered results show up fine.

## Known pitfalls

- `az pipelines runs tasks list` — **does not exist**. Errors immediately with no usable output.
  Use the timeline API (Step 2) instead.
- A pipeline YAML file existing in the repo does not mean it has ever run in ADO — check
  `az pipelines build list` for the actual definition ID before assuming build history exists.
  (Definitions can be registered in ADO well after the YAML was committed.)
- `--result <value>` on `build list`/`build show` filters silently rather than erroring on a typo;
  if you get zero results, re-run without the filter before concluding there's no matching build.
