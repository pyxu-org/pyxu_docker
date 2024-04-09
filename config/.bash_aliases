# Helper functions ============================================================
append_to() {
    # append_to $1 $2
    #    Append $2[str] to $1[var_name] when not already inside.
    #
    # Example
    # -------
    # $ PATH=""
    # $ append_to PATH abc
    # $ echo ${PATH}                 # abc
    # $ append_to PATH def
    # $ echo ${PATH}                 # abc:def
    # $ append_to PATH abc
    # $ echo ${PATH}                 # abc:def -> no change since already included

    if [ "${#}" -ne 2 ]; then
        echo "Usage: append_to <variable_name> <data>"
        return 1
    fi

    variable="${1}"
    case ":${!variable}:" in
        *:"${2}":*)
            ;;
        *)
            eval ${variable}="${!variable:+${!variable}:}${2}"
    esac
}

# Customize Shell Environment =================================================
eval "$(starship init bash)"
bind -s 'set completion-ignore-case on'  # case-insensitive auto-complete

# Unlimited Bash History ======================================================
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=                         # no maximum number of lines in history
export HISTFILESIZE=                     # no file size limit
shopt -s histappend                      # append to history, don't overwrite it
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

# PATH ADDITIONS ==============================================================
append_to PATH ~/tools/  # extra binary utilities
export PATH

# ADD-ON COMMANDS =============================================================
# Terminal Tools
alias by='byobu'
alias ca='ce; conda activate'  # conda activate <env>
alias cat='cat --number'
alias ce='eval "$(~/tools/miniconda3/bin/conda shell.bash hook)"'  # conda_enable
alias copy='rsync -ahcvP'
alias dd='dd bs=32M status=progress'
alias detox='detox -s utf_8 -r'
alias grep='grep --color=auto'
alias l='clear; lsd -lhF --color=never --icon=auto --date=+%Y-%m-%d@%H:%M:%S'
alias less='less --LINE-NUMBERS'
alias lg='lazygit'
alias nano='nano -c --smarthome --tabstospaces --tabsize=4 --wordbounds --autoindent --fill=120 --linenumbers'
alias ncdu="ncdu --color=off"
alias p3='ipython3'

# Default Tools ===============================================================
export EDITOR=/usr/bin/nano
