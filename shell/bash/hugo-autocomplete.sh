# bash completion for hugo                                 -*- shell-script -*-

__hugo_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__hugo_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__hugo_index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__hugo_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__hugo_handle_go_custom_completion()
{
    __hugo_debug "${FUNCNAME[0]}: cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}"

    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local out requestComp lastParam lastChar comp directive args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly hugo allows to handle aliases
    args=("${words[@]:1}")
    requestComp="${words[0]} __completeNoDesc ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __hugo_debug "${FUNCNAME[0]}: lastParam ${lastParam}, lastChar ${lastChar}"

    if [ -z "${cur}" ] && [ "${lastChar}" != "=" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __hugo_debug "${FUNCNAME[0]}: Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __hugo_debug "${FUNCNAME[0]}: calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:)
    directive=${out##*:}
    # Remove the directive
    out=${out%:*}
    if [ "${directive}" = "${out}" ]; then
        # There is not directive specified
        directive=0
    fi
    __hugo_debug "${FUNCNAME[0]}: the completion directive is: ${directive}"
    __hugo_debug "${FUNCNAME[0]}: the completions are: ${out[*]}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        # Error code.  No completion.
        __hugo_debug "${FUNCNAME[0]}: received error from custom completion go code"
        return
    else
        if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __hugo_debug "${FUNCNAME[0]}: activating no space"
                compopt -o nospace
            fi
        fi
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __hugo_debug "${FUNCNAME[0]}: activating no file completion"
                compopt +o default
            fi
        fi
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local fullFilter filter filteringCmd
        # Do not use quotes around the $out variable or else newline
        # characters will be kept.
        for filter in ${out[*]}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __hugo_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        # Use printf to strip any trailing newline
        subdir=$(printf "%s" "${out[0]}")
        if [ -n "$subdir" ]; then
            __hugo_debug "Listing directories in $subdir"
            __hugo_handle_subdirs_in_dir_flag "$subdir"
        else
            __hugo_debug "Listing directories in ."
            _filedir -d
        fi
    else
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${out[*]}" -- "$cur")
    fi
}

__hugo_handle_reply()
{
    __hugo_debug "${FUNCNAME[0]}"
    local comp
    case $cur in
        -*)
            if [[ $(type -t compopt) = "builtin" ]]; then
                compopt -o nospace
            fi
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            while IFS='' read -r comp; do
                COMPREPLY+=("$comp")
            done < <(compgen -W "${allflags[*]}" -- "$cur")
            if [[ $(type -t compopt) = "builtin" ]]; then
                [[ "${COMPREPLY[0]}" == *= ]] || compopt +o nospace
            fi

            # complete after --flag=abc
            if [[ $cur == *=* ]]; then
                if [[ $(type -t compopt) = "builtin" ]]; then
                    compopt +o nospace
                fi

                local index flag
                flag="${cur%=*}"
                __hugo_index_of_word "${flag}" "${flags_with_completion[@]}"
                COMPREPLY=()
                if [[ ${index} -ge 0 ]]; then
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION}" ]; then
                        # zsh completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi
            return 0;
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __hugo_index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    completions=("${commands[@]}")
    if [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions+=("${must_have_one_noun[@]}")
    elif [[ -n "${has_completion_function}" ]]; then
        # if a go completion function is provided, defer to that function
        __hugo_handle_go_custom_completion
    fi
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions+=("${must_have_one_flag[@]}")
    fi
    while IFS='' read -r comp; do
        COMPREPLY+=("$comp")
    done < <(compgen -W "${completions[*]}" -- "$cur")

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${noun_aliases[*]}" -- "$cur")
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
		if declare -F __hugo_custom_func >/dev/null; then
			# try command name qualified custom func
			__hugo_custom_func
		else
			# otherwise fall back to unqualified for compatibility
			declare -F __custom_func >/dev/null && __custom_func
		fi
    fi

    # available in bash-completion >= 2, not always present on macOS
    if declare -F __ltrim_colon_completions >/dev/null; then
        __ltrim_colon_completions "$cur"
    fi

    # If there is only 1 completion and it is a flag with an = it will be completed
    # but we don't want a space after the =
    if [[ "${#COMPREPLY[@]}" -eq "1" ]] && [[ $(type -t compopt) = "builtin" ]] && [[ "${COMPREPLY[0]}" == --*= ]]; then
       compopt -o nospace
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__hugo_handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__hugo_handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
}

__hugo_handle_flag()
{
    __hugo_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __hugo_debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __hugo_contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __hugo_contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
      commands=()
    fi

    # keep flag value with flagname as flaghash
    # flaghash variable is an associative array which is only supported in bash > 3.
    if [[ -z "${BASH_VERSION}" || "${BASH_VERSINFO[0]}" -gt 3 ]]; then
        if [ -n "${flagvalue}" ] ; then
            flaghash[${flagname}]=${flagvalue}
        elif [ -n "${words[ $((c+1)) ]}" ] ; then
            flaghash[${flagname}]=${words[ $((c+1)) ]}
        else
            flaghash[${flagname}]="true" # pad "true" for bool flag
        fi
    fi

    # skip the argument to a two word flag
    if [[ ${words[c]} != *"="* ]] && __hugo_contains_word "${words[c]}" "${two_word_flags[@]}"; then
			  __hugo_debug "${FUNCNAME[0]}: found a flag ${words[c]}, skip the next argument"
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__hugo_handle_noun()
{
    __hugo_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __hugo_contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __hugo_contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__hugo_handle_command()
{
    __hugo_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_hugo_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __hugo_debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__hugo_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __hugo_handle_reply
        return
    fi
    __hugo_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __hugo_handle_flag
    elif __hugo_contains_word "${words[c]}" "${commands[@]}"; then
        __hugo_handle_command
    elif [[ $c -eq 0 ]]; then
        __hugo_handle_command
    elif __hugo_contains_word "${words[c]}" "${command_aliases[@]}"; then
        # aliashash variable is an associative array which is only supported in bash > 3.
        if [[ -z "${BASH_VERSION}" || "${BASH_VERSINFO[0]}" -gt 3 ]]; then
            words[c]=${aliashash[${words[c]}]}
            __hugo_handle_command
        else
            __hugo_handle_noun
        fi
    else
        __hugo_handle_noun
    fi
    __hugo_handle_word
}

_hugo_config_mounts()
{
    last_command="hugo_config_mounts"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_config()
{
    last_command="hugo_config"

    command_aliases=()

    commands=()
    commands+=("mounts")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert_toJSON()
{
    last_command="hugo_convert_toJSON"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--unsafe")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert_toTOML()
{
    last_command="hugo_convert_toTOML"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--unsafe")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert_toYAML()
{
    last_command="hugo_convert_toYAML"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--unsafe")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert()
{
    last_command="hugo_convert"

    command_aliases=()

    commands=()
    commands+=("toJSON")
    commands+=("toTOML")
    commands+=("toYAML")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    flags+=("--unsafe")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_deploy()
{
    last_command="hugo_deploy"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--confirm")
    local_nonpersistent_flags+=("--confirm")
    flags+=("--dryRun")
    local_nonpersistent_flags+=("--dryRun")
    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--invalidateCDN")
    local_nonpersistent_flags+=("--invalidateCDN")
    flags+=("--maxDeletes=")
    two_word_flags+=("--maxDeletes")
    local_nonpersistent_flags+=("--maxDeletes")
    local_nonpersistent_flags+=("--maxDeletes=")
    flags+=("--target=")
    two_word_flags+=("--target")
    local_nonpersistent_flags+=("--target")
    local_nonpersistent_flags+=("--target=")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_env()
{
    last_command="hugo_env"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_autocomplete()
{
    last_command="hugo_gen_autocomplete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--completionfile=")
    two_word_flags+=("--completionfile")
    two_word_flags+=("-f")
    flags+=("--help")
    flags+=("-h")
    local_nonpersistent_flags+=("--help")
    local_nonpersistent_flags+=("-h")
    flags+=("--type=")
    two_word_flags+=("--type")
    two_word_flags+=("-t")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_chromastyles()
{
    last_command="hugo_gen_chromastyles"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--highlightStyle=")
    two_word_flags+=("--highlightStyle")
    flags+=("--linesStyle=")
    two_word_flags+=("--linesStyle")
    flags+=("--style=")
    two_word_flags+=("--style")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_doc()
{
    last_command="hugo_gen_doc"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    two_word_flags+=("--dir")
    flags_with_completion+=("--dir")
    flags_completion+=("_filedir -d")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_man()
{
    last_command="hugo_gen_man"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    two_word_flags+=("--dir")
    flags_with_completion+=("--dir")
    flags_completion+=("_filedir -d")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen()
{
    last_command="hugo_gen"

    command_aliases=()

    commands=()
    commands+=("autocomplete")
    commands+=("chromastyles")
    commands+=("doc")
    commands+=("man")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_help()
{
    last_command="hugo_help"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_hugo_import_jekyll()
{
    last_command="hugo_import_jekyll"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_import()
{
    last_command="hugo_import"

    command_aliases=()

    commands=()
    commands+=("jekyll")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_all()
{
    last_command="hugo_list_all"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_drafts()
{
    last_command="hugo_list_drafts"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_expired()
{
    last_command="hugo_list_expired"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_future()
{
    last_command="hugo_list_future"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list()
{
    last_command="hugo_list"

    command_aliases=()

    commands=()
    commands+=("all")
    commands+=("drafts")
    commands+=("expired")
    commands+=("future")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_clean()
{
    last_command="hugo_mod_clean"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    local_nonpersistent_flags+=("--all")
    flags+=("--pattern=")
    two_word_flags+=("--pattern")
    local_nonpersistent_flags+=("--pattern")
    local_nonpersistent_flags+=("--pattern=")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_get()
{
    last_command="hugo_mod_get"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_graph()
{
    last_command="hugo_mod_graph"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_init()
{
    last_command="hugo_mod_init"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_npm_pack()
{
    last_command="hugo_mod_npm_pack"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_npm()
{
    last_command="hugo_mod_npm"

    command_aliases=()

    commands=()
    commands+=("pack")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_tidy()
{
    last_command="hugo_mod_tidy"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_vendor()
{
    last_command="hugo_mod_vendor"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod_verify()
{
    last_command="hugo_mod_verify"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--clean")
    local_nonpersistent_flags+=("--clean")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_mod()
{
    last_command="hugo_mod"

    command_aliases=()

    commands=()
    commands+=("clean")
    commands+=("get")
    commands+=("graph")
    commands+=("init")
    commands+=("npm")
    commands+=("tidy")
    commands+=("vendor")
    commands+=("verify")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--baseURL=")
    two_word_flags+=("--baseURL")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL")
    local_nonpersistent_flags+=("--baseURL=")
    local_nonpersistent_flags+=("-b")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    local_nonpersistent_flags+=("-D")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    local_nonpersistent_flags+=("-E")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    local_nonpersistent_flags+=("-F")
    flags+=("--cacheDir=")
    two_word_flags+=("--cacheDir")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--contentDir=")
    two_word_flags+=("--contentDir")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir")
    local_nonpersistent_flags+=("--contentDir=")
    local_nonpersistent_flags+=("-c")
    flags+=("--destination=")
    two_word_flags+=("--destination")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination")
    local_nonpersistent_flags+=("--destination=")
    local_nonpersistent_flags+=("-d")
    flags+=("--disableKinds=")
    two_word_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--gc")
    local_nonpersistent_flags+=("--gc")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--layoutDir=")
    two_word_flags+=("--layoutDir")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir")
    local_nonpersistent_flags+=("--layoutDir=")
    local_nonpersistent_flags+=("-l")
    flags+=("--minify")
    local_nonpersistent_flags+=("--minify")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--path-warnings")
    local_nonpersistent_flags+=("--path-warnings")
    flags+=("--print-mem")
    local_nonpersistent_flags+=("--print-mem")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    two_word_flags+=("--theme")
    flags_with_completion+=("--theme")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme")
    local_nonpersistent_flags+=("--theme=")
    local_nonpersistent_flags+=("-t")
    flags+=("--trace=")
    two_word_flags+=("--trace")
    local_nonpersistent_flags+=("--trace")
    local_nonpersistent_flags+=("--trace=")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_new_site()
{
    last_command="hugo_new_site"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--format=")
    two_word_flags+=("--format")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--format")
    local_nonpersistent_flags+=("--format=")
    local_nonpersistent_flags+=("-f")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_new_theme()
{
    last_command="hugo_new_theme"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_new()
{
    last_command="hugo_new"

    command_aliases=()

    commands=()
    commands+=("site")
    commands+=("theme")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--baseURL=")
    two_word_flags+=("--baseURL")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL")
    local_nonpersistent_flags+=("--baseURL=")
    local_nonpersistent_flags+=("-b")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    local_nonpersistent_flags+=("-D")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    local_nonpersistent_flags+=("-E")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    local_nonpersistent_flags+=("-F")
    flags+=("--cacheDir=")
    two_word_flags+=("--cacheDir")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--contentDir=")
    two_word_flags+=("--contentDir")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir")
    local_nonpersistent_flags+=("--contentDir=")
    local_nonpersistent_flags+=("-c")
    flags+=("--destination=")
    two_word_flags+=("--destination")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination")
    local_nonpersistent_flags+=("--destination=")
    local_nonpersistent_flags+=("-d")
    flags+=("--disableKinds=")
    two_word_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--editor=")
    two_word_flags+=("--editor")
    local_nonpersistent_flags+=("--editor")
    local_nonpersistent_flags+=("--editor=")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--gc")
    local_nonpersistent_flags+=("--gc")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--kind=")
    two_word_flags+=("--kind")
    two_word_flags+=("-k")
    local_nonpersistent_flags+=("--kind")
    local_nonpersistent_flags+=("--kind=")
    local_nonpersistent_flags+=("-k")
    flags+=("--layoutDir=")
    two_word_flags+=("--layoutDir")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir")
    local_nonpersistent_flags+=("--layoutDir=")
    local_nonpersistent_flags+=("-l")
    flags+=("--minify")
    local_nonpersistent_flags+=("--minify")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--path-warnings")
    local_nonpersistent_flags+=("--path-warnings")
    flags+=("--print-mem")
    local_nonpersistent_flags+=("--print-mem")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    two_word_flags+=("--theme")
    flags_with_completion+=("--theme")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme")
    local_nonpersistent_flags+=("--theme=")
    local_nonpersistent_flags+=("-t")
    flags+=("--trace=")
    two_word_flags+=("--trace")
    local_nonpersistent_flags+=("--trace")
    local_nonpersistent_flags+=("--trace=")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_server()
{
    last_command="hugo_server"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--appendPort")
    local_nonpersistent_flags+=("--appendPort")
    flags+=("--baseURL=")
    two_word_flags+=("--baseURL")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL")
    local_nonpersistent_flags+=("--baseURL=")
    local_nonpersistent_flags+=("-b")
    flags+=("--bind=")
    two_word_flags+=("--bind")
    local_nonpersistent_flags+=("--bind")
    local_nonpersistent_flags+=("--bind=")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    local_nonpersistent_flags+=("-D")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    local_nonpersistent_flags+=("-E")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    local_nonpersistent_flags+=("-F")
    flags+=("--cacheDir=")
    two_word_flags+=("--cacheDir")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--contentDir=")
    two_word_flags+=("--contentDir")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir")
    local_nonpersistent_flags+=("--contentDir=")
    local_nonpersistent_flags+=("-c")
    flags+=("--destination=")
    two_word_flags+=("--destination")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination")
    local_nonpersistent_flags+=("--destination=")
    local_nonpersistent_flags+=("-d")
    flags+=("--disableBrowserError")
    local_nonpersistent_flags+=("--disableBrowserError")
    flags+=("--disableFastRender")
    local_nonpersistent_flags+=("--disableFastRender")
    flags+=("--disableKinds=")
    two_word_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--disableLiveReload")
    local_nonpersistent_flags+=("--disableLiveReload")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--gc")
    local_nonpersistent_flags+=("--gc")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--layoutDir=")
    two_word_flags+=("--layoutDir")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir")
    local_nonpersistent_flags+=("--layoutDir=")
    local_nonpersistent_flags+=("-l")
    flags+=("--liveReloadPort=")
    two_word_flags+=("--liveReloadPort")
    local_nonpersistent_flags+=("--liveReloadPort")
    local_nonpersistent_flags+=("--liveReloadPort=")
    flags+=("--meminterval=")
    two_word_flags+=("--meminterval")
    local_nonpersistent_flags+=("--meminterval")
    local_nonpersistent_flags+=("--meminterval=")
    flags+=("--memstats=")
    two_word_flags+=("--memstats")
    local_nonpersistent_flags+=("--memstats")
    local_nonpersistent_flags+=("--memstats=")
    flags+=("--minify")
    local_nonpersistent_flags+=("--minify")
    flags+=("--navigateToChanged")
    local_nonpersistent_flags+=("--navigateToChanged")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noHTTPCache")
    local_nonpersistent_flags+=("--noHTTPCache")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--path-warnings")
    local_nonpersistent_flags+=("--path-warnings")
    flags+=("--port=")
    two_word_flags+=("--port")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--port")
    local_nonpersistent_flags+=("--port=")
    local_nonpersistent_flags+=("-p")
    flags+=("--print-mem")
    local_nonpersistent_flags+=("--print-mem")
    flags+=("--renderToDisk")
    local_nonpersistent_flags+=("--renderToDisk")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    two_word_flags+=("--theme")
    flags_with_completion+=("--theme")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme")
    local_nonpersistent_flags+=("--theme=")
    local_nonpersistent_flags+=("-t")
    flags+=("--trace=")
    two_word_flags+=("--trace")
    local_nonpersistent_flags+=("--trace")
    local_nonpersistent_flags+=("--trace=")
    flags+=("--watch")
    flags+=("-w")
    local_nonpersistent_flags+=("--watch")
    local_nonpersistent_flags+=("-w")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_version()
{
    last_command="hugo_version"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--debug")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_root_command()
{
    last_command="hugo"

    command_aliases=()

    commands=()
    commands+=("config")
    commands+=("convert")
    commands+=("deploy")
    commands+=("env")
    commands+=("gen")
    commands+=("help")
    commands+=("import")
    commands+=("list")
    commands+=("mod")
    commands+=("new")
    commands+=("server")
    if [[ -z "${BASH_VERSION}" || "${BASH_VERSINFO[0]}" -gt 3 ]]; then
        command_aliases+=("serve")
        aliashash["serve"]="server"
    fi
    commands+=("version")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--baseURL=")
    two_word_flags+=("--baseURL")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL")
    local_nonpersistent_flags+=("--baseURL=")
    local_nonpersistent_flags+=("-b")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    local_nonpersistent_flags+=("-D")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    local_nonpersistent_flags+=("-E")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    local_nonpersistent_flags+=("-F")
    flags+=("--cacheDir=")
    two_word_flags+=("--cacheDir")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__hugo_handle_filename_extension_flag toml|yaml|yml|json")
    flags+=("--configDir=")
    two_word_flags+=("--configDir")
    flags+=("--contentDir=")
    two_word_flags+=("--contentDir")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir")
    local_nonpersistent_flags+=("--contentDir=")
    local_nonpersistent_flags+=("-c")
    flags+=("--debug")
    flags+=("--destination=")
    two_word_flags+=("--destination")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination")
    local_nonpersistent_flags+=("--destination=")
    local_nonpersistent_flags+=("-d")
    flags+=("--disableKinds=")
    two_word_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--environment=")
    two_word_flags+=("--environment")
    two_word_flags+=("-e")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--gc")
    local_nonpersistent_flags+=("--gc")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--ignoreVendor")
    flags+=("--ignoreVendorPaths=")
    two_word_flags+=("--ignoreVendorPaths")
    flags+=("--layoutDir=")
    two_word_flags+=("--layoutDir")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir")
    local_nonpersistent_flags+=("--layoutDir=")
    local_nonpersistent_flags+=("-l")
    flags+=("--log")
    flags+=("--logFile=")
    two_word_flags+=("--logFile")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--minify")
    local_nonpersistent_flags+=("--minify")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--path-warnings")
    local_nonpersistent_flags+=("--path-warnings")
    flags+=("--print-mem")
    local_nonpersistent_flags+=("--print-mem")
    flags+=("--quiet")
    flags+=("--renderToMemory")
    local_nonpersistent_flags+=("--renderToMemory")
    flags+=("--source=")
    two_word_flags+=("--source")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    two_word_flags+=("--theme")
    flags_with_completion+=("--theme")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__hugo_handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme")
    local_nonpersistent_flags+=("--theme=")
    local_nonpersistent_flags+=("-t")
    flags+=("--themesDir=")
    two_word_flags+=("--themesDir")
    flags+=("--trace=")
    two_word_flags+=("--trace")
    local_nonpersistent_flags+=("--trace")
    local_nonpersistent_flags+=("--trace=")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")
    flags+=("--watch")
    flags+=("-w")
    local_nonpersistent_flags+=("--watch")
    local_nonpersistent_flags+=("-w")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_hugo()
{
    local cur prev words cword
    declare -A flaghash 2>/dev/null || :
    declare -A aliashash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __hugo_init_completion -n "=" || return
    fi

    local c=0
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("hugo")
    local must_have_one_flag=()
    local must_have_one_noun=()
    local has_completion_function
    local last_command
    local nouns=()

    __hugo_handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_hugo hugo
else
    complete -o default -o nospace -F __start_hugo hugo
fi

# ex: ts=4 sw=4 et filetype=sh
