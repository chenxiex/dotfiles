### Prompt

autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz vcs_info
colors
zmodload zsh/datetime

setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '*'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats '%b%c%u'
zstyle ':vcs_info:git:*' actionformats '%b%c%u'

# Prompt state used by PROMPT. These values are refreshed by zle/precmd hooks.
_PROMPT_VI_SYMBOL=">"
_PROMPT_CONTEXT=
_PROMPT_GIT=
_PROMPT_STATUS_COLOR="green"
_PROMPT_COMMAND_START=
_PROMPT_COMMAND_DURATION=

# Show command duration when the previous command ran for at least this many seconds.
: ${PROMPT_COMMAND_DURATION_THRESHOLD:=5}

# Show user@host only when the shell is likely outside the local host context.
function _prompt_in_remote_or_container() {
    [[ -n $SSH_CONNECTION ]] \
        || [[ -f /run/.containerenv ]] \
        || grep -qE '(docker|kubepods|containerd)' /proc/1/cgroup 2>/dev/null
}

# Keep the vi indicator in sync with the active zle keymap.
function _prompt_update_vi_symbol() {
    case $KEYMAP in
        vicmd)
            _PROMPT_VI_SYMBOL="<"
            ;;
        viins|main)
            _PROMPT_VI_SYMBOL=">"
            ;;
    esac

    zle reset-prompt
}

function zle-line-init zle-keymap-select {
    _prompt_update_vi_symbol
}

zle -N zle-line-init
zle -N zle-keymap-select

# Choose the prompt color from the previous command status and privilege level.
function _prompt_status_color() {
    local exit_status=$1

    if (( EUID == 0 )); then
        (( exit_status == 0 )) && print -r -- cyan || print -r -- magenta
    else
        (( exit_status == 0 )) && print -r -- green || print -r -- red
    fi
}

# Remember when an external command starts so precmd can measure its duration.
function _prompt_preexec() {
    _PROMPT_COMMAND_START=$EPOCHREALTIME
}

# Escape percent signs before storing VCS text in PROMPT_SUBST variables.
function _prompt_escape() {
    print -r -- "${1//\%/%%}"
}

# Refresh the local VCS branch/ref and dirty marker. No remote/upstream checks.
function _prompt_update_git_info() {
    _PROMPT_GIT=

    vcs_info
    [[ -n $vcs_info_msg_0_ ]] || return

    local ref dirty_marker

    ref=${vcs_info_msg_0_%%\**}
    if [[ $vcs_info_msg_0_ == *\* ]]; then
        dirty_marker="*"
    fi

    _PROMPT_GIT=" %F{242}$(_prompt_escape "$ref")%F{yellow}${dirty_marker}%f"
}

# Format a duration in seconds for the first-line right edge.
function _prompt_format_duration() {
    local elapsed=$1
    local total_seconds hours minutes seconds

    total_seconds=${elapsed%.*}
    hours=$(( total_seconds / 3600 ))
    minutes=$(( (total_seconds % 3600) / 60 ))
    seconds=$(( total_seconds % 60 ))

    if (( hours > 0 )); then
        printf '%dh%02dm' "$hours" "$minutes"
    elif (( minutes > 0 )); then
        printf '%dm%02ds' "$minutes" "$seconds"
    else
        printf '%.1fs' "$elapsed"
    fi
}

# Return the previous command duration when it crossed the configured threshold.
function _prompt_command_duration() {
    [[ -n $_PROMPT_COMMAND_START ]] || return

    local elapsed
    elapsed=$(( EPOCHREALTIME - _PROMPT_COMMAND_START ))
    _PROMPT_COMMAND_START=

    (( elapsed >= PROMPT_COMMAND_DURATION_THRESHOLD )) || return
    _prompt_format_duration "$elapsed"
}

# Refresh context and status just before each prompt is drawn.
function _prompt_precmd() {
    local exit_status=$?
    local duration

    if _prompt_in_remote_or_container; then
        _PROMPT_CONTEXT="%n@%m "
    else
        _PROMPT_CONTEXT=
    fi

    _prompt_update_git_info
    duration="$(_prompt_command_duration)"
    if [[ -n $duration ]]; then
        _PROMPT_COMMAND_DURATION="%F{242}${duration}%f"
    else
        _PROMPT_COMMAND_DURATION=
    fi
    _PROMPT_STATUS_COLOR="$(_prompt_status_color "$exit_status")"
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd

PROMPT='
[${_PROMPT_CONTEXT}%F{blue}%~%f]${_PROMPT_GIT}
%F{${_PROMPT_STATUS_COLOR}}${_PROMPT_VI_SYMBOL}%f '
RPROMPT='${_PROMPT_COMMAND_DURATION}'

### End of prompt
