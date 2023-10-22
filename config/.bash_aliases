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

# PATH ADDITIONS ==============================================================
append_to PATH ~/tools/  # extra binary utilities
append_to PATH ~/tools/miniconda3/bin/  # Miniconda install
export PATH

# ADD-ON COMMANDS =============================================================
# Terminal Tools
alias grep='grep --color=auto'
alias nano='nano -c --smarthome --tabstospaces --tabsize=4 --wordbounds --autoindent --fill=120 --linenumbers'

# Default Tools ===============================================================
export EDITOR=/usr/bin/nano
