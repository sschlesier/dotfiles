#!/usr/bin/env bash

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

color_remaining() {
    local val=$1
    if   [[ $val -le 5  ]]; then printf '%s' "$RED"
    elif [[ $val -le 20 ]]; then printf '%s' "$YLW"
    else                          printf '%s' "$GRN"
    fi
}

fmt_pct() {
    local label=$1 val=$2
    printf '%s%s%s%s%s%%%s' "$DIM" "$label" "$RST" "$(color_pct "$val")" "$val" "$RST"
}

fmt_remaining() {
    local label=$1 val=$2
    printf '%s%s%s%s%s%%%s' "$DIM" "$label" "$RST" "$(color_remaining "$val")" "$val" "$RST"
}

# Return human-readable time until an ISO-8601 UTC timestamp (e.g. "1h42m", "38m")
time_until() {
    local ts=$1
    [[ -z "$ts" ]] && return
    local epoch
    epoch=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "${ts%%.*}" "+%s" 2>/dev/null)
    [[ -z "$epoch" ]] && return
    local diff=$(( epoch - $(date +%s) ))
    [[ $diff -le 0 ]] && { printf 'soon'; return; }
    local h=$(( diff / 3600 )) m=$(( (diff % 3600) / 60 ))
    [[ $h -gt 0 ]] && printf '%dh%dm' "$h" "$m" || printf '%dm' "$m"
}

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
    GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
    COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)"
    if [[ "$GIT_DIR" != "$COMMON_DIR" ]]; then
        REPO="$(basename "$(dirname "$COMMON_DIR")")"
        REPO_SEP="@"
    else
        REPO="$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")"
        REPO_SEP="/"
    fi
    if [[ "$GIT_DIR" != "$COMMON_DIR" ]]; then
        LOC_PART="${GRN}🌲${RST} ${DIM}${REPO}${REPO_SEP}${BRANCH}${RST}"
    else
        LOC_PART="${DIM}${REPO}${REPO_SEP}${BRANCH}${RST}"
    fi
else
    SHORT_PWD="${PWD/#$HOME/~}"
    LOC_PART="${DIM}${SHORT_PWD}${RST}"
fi

# ── Usage from stdin rate_limits ──────────────────────────────────────────────

# Claude Code passes used_percentage (0-100); fall back to utilization for older field name
FIVE_H_USED="$(printf '%s' "$INPUT" | jq -r '
    .rate_limits.five_hour.used_percentage //
    .rate_limits.five_hour.utilization //
    empty' 2>/dev/null | cut -d. -f1)"

SEVEN_D_USED="$(printf '%s' "$INPUT" | jq -r '
    .rate_limits.seven_day.used_percentage //
    .rate_limits.seven_day.utilization //
    empty' 2>/dev/null | cut -d. -f1)"

FIVE_H_RESET="$(printf '%s' "$INPUT" | jq -r '.rate_limits.five_hour.resets_at // empty' 2>/dev/null)"
SEVEN_D_RESET="$(printf '%s' "$INPUT" | jq -r '.rate_limits.seven_day.resets_at // empty' 2>/dev/null)"

# ── Build output ──────────────────────────────────────────────────────────────

SEP="  ${DIM}│${RST}  "

CTX_PART="$(fmt_pct "ctx " "$CTX_PCT")"

if [[ -z "$FIVE_H_USED" && -z "$SEVEN_D_USED" ]]; then
    USAGE_PART="${DIM}no usage data${RST}"
else
    FIVE_H_USED="${FIVE_H_USED:-0}"
    SEVEN_D_USED="${SEVEN_D_USED:-0}"
    FIVE_H=$(( 100 - FIVE_H_USED ))
    SEVEN_D=$(( 100 - SEVEN_D_USED ))

    FIVE_H_PART="$(fmt_remaining "5h " "$FIVE_H")"
    if [[ $FIVE_H_USED -ge 80 ]]; then
        FIVE_H_TTR="$(time_until "$FIVE_H_RESET")"
        [[ -n "$FIVE_H_TTR" ]] && FIVE_H_PART="${FIVE_H_PART} ${DIM}↺${RST}${FIVE_H_TTR}"
    fi

    SEVEN_D_PART="$(fmt_remaining "7d " "$SEVEN_D")"
    if [[ $SEVEN_D_USED -ge 95 ]]; then
        SEVEN_D_TTR="$(time_until "$SEVEN_D_RESET")"
        [[ -n "$SEVEN_D_TTR" ]] && SEVEN_D_PART="${SEVEN_D_PART} ${DIM}↺${RST}${SEVEN_D_TTR}"
    fi

    USAGE_PART="${FIVE_H_PART}${SEP}${SEVEN_D_PART}"
fi

printf '%s\n' "${LOC_PART}${SEP}${CTX_PART}${SEP}${USAGE_PART}${SEP}${MODEL}"
