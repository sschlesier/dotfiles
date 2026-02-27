#!/usr/bin/env bash

CACHE_FILE="/tmp/claude_statusline_usage.json"
CACHE_TTL=120  # seconds

# ── Colors ────────────────────────────────────────────────────────────────────

RED=$'\033[91m'
YLW=$'\033[93m'
GRN=$'\033[32m'
DIM=$'\033[2m'
RST=$'\033[0m'

color_pct() {
    local val=$1
    if   [[ $val -ge 95 ]]; then printf '%s' "$RED"
    elif [[ $val -ge 80 ]]; then printf '%s' "$YLW"
    else                          printf '%s' "$GRN"
    fi
}

fmt_pct() {
    local label=$1 val=$2
    printf '%s%s%s%s%s%%%s' "$DIM" "$label" "$RST" "$(color_pct "$val")" "$val" "$RST"
}

# ── --refresh: bust cache and exit ────────────────────────────────────────────

if [[ "${1:-}" == "--refresh" ]]; then
    if [[ -f "$CACHE_FILE" ]]; then
        rm -f "$CACHE_FILE"
        echo "Cache cleared — next statusline render will fetch fresh usage data."
    else
        echo "No cache to clear."
    fi
    exit 0
fi

# ── Read Claude Code JSON from stdin ─────────────────────────────────────────

INPUT="$(cat)"

MODEL="$(printf '%s' "$INPUT" | jq -r '.model.display_name // "unknown"' 2>/dev/null)"
MODEL="${MODEL:-unknown}"

CTX_RAW="$(printf '%s' "$INPUT" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)"
CTX_PCT="${CTX_RAW%.*}"

# ── Git branch ────────────────────────────────────────────────────────────────

if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH="$(git branch --show-current 2>/dev/null)"
    BRANCH="${BRANCH:-detached}"
    REPO="$(basename "$(dirname "$(git rev-parse --git-common-dir 2>/dev/null)")")"
    GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
    COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)"
    if [[ "$GIT_DIR" != "$COMMON_DIR" ]]; then
        REPO_SEP="@"
    else
        REPO_SEP="/"
    fi
else
    BRANCH=""
    REPO=""
    REPO_SEP="/"
fi

# ── Usage fetch (called only when cache is stale) ─────────────────────────────

fetch_usage() {
    CREDS_JSON="$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)"
    if [[ -z "$CREDS_JSON" ]]; then
        printf 'ERR:no-creds'
        return
    fi

    ACCESS_TOKEN="$(printf '%s' "$CREDS_JSON" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)"
    if [[ -z "$ACCESS_TOKEN" ]]; then
        printf 'ERR:no-token'
        return
    fi

    RESP="$(curl -sf --max-time 5 \
        -H "Accept: application/json" \
        -H "User-Agent: claude-code/2.0.31" \
        -H "Authorization: Bearer ${ACCESS_TOKEN}" \
        -H "anthropic-beta: oauth-2025-04-20" \
        "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)"

    if [[ -z "$RESP" ]]; then
        printf 'ERR:api-timeout'
        return
    fi

    if ! printf '%s' "$RESP" | jq -e '.five_hour' > /dev/null 2>&1; then
        printf 'ERR:bad-response'
        return
    fi

    printf '%s' "$RESP"
}

# ── Cache logic ───────────────────────────────────────────────────────────────

USAGE_DATA=""
if [[ -f "$CACHE_FILE" ]]; then
    CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
    if [[ $CACHE_AGE -lt $CACHE_TTL ]]; then
        USAGE_DATA="$(cat "$CACHE_FILE")"
    fi
fi

if [[ -z "$USAGE_DATA" ]]; then
    USAGE_DATA="$(fetch_usage)"
    if [[ "$USAGE_DATA" != ERR:* ]]; then
        printf '%s' "$USAGE_DATA" > "$CACHE_FILE"
    fi
fi

# ── Cache age label ───────────────────────────────────────────────────────────

# Read mtime of cache file (valid after both cache-hit and fresh-write paths)
AGE_PART=""
if [[ -f "$CACHE_FILE" ]]; then
    FILE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
    if   [[ $FILE_AGE -lt 5  ]]; then AGE_STR="now"
    elif [[ $FILE_AGE -lt 60 ]]; then AGE_STR="${FILE_AGE}s ago"
    else                               AGE_STR="$(( FILE_AGE / 60 ))m ago"
    fi
    AGE_PART="${DIM}↻ ${AGE_STR}${RST}"
fi

# ── Build output ──────────────────────────────────────────────────────────────

SEP="  ${DIM}│${RST}  "

CTX_PART="$(fmt_pct "ctx " "$CTX_PCT")"

if [[ "$USAGE_DATA" == ERR:* ]]; then
    ERR="${USAGE_DATA#ERR:}"
    USAGE_PART="${RED}[${ERR}]${RST}"
else
    FIVE_H="$(printf '%s' "$USAGE_DATA" | jq -r '.five_hour.utilization // 0' 2>/dev/null | cut -d. -f1)"
    SEVEN_D="$(printf '%s' "$USAGE_DATA" | jq -r '.seven_day.utilization // 0' 2>/dev/null | cut -d. -f1)"
    USAGE_PART="$(fmt_pct "5h " "$FIVE_H")${SEP}$(fmt_pct "7d " "$SEVEN_D")"
fi

PARTS=""
[[ -n "$BRANCH" ]] && PARTS="${DIM}${REPO}${REPO_SEP}${BRANCH}${RST}${SEP}"
PARTS="${PARTS}${CTX_PART}${SEP}${USAGE_PART}"
[[ -n "$AGE_PART" ]] && PARTS="${PARTS}  ${AGE_PART}"
PARTS="${PARTS}${SEP}${MODEL}"

printf '%s\n' "$PARTS"
