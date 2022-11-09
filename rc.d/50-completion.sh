#!/bin/bash -p

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[ -f '/usr/local/bin/aws_bash_completer' ] && source '/usr/local/bin/aws_bash_completer'
[[ -e /opt/homebrew/bin/kubectl ]] && source <(kubectl completion bash)

_saved_marks()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts=$(marks | awk '{ print $1 }')

    case "$COMP_CWORD" in
	1) COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
	   return 0
	   ;;
	2) local pdir=path_${prev}
	   local dir=$(eval echo '${'$pdir'}')
	   local subdirs=$(ls -F $dir | grep /$)
	   COMPREPLY=($(compgen -W "${subdirs}" -- ${cur}))
	   return 0
	   ;;
    esac

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0    
}

complete -F _saved_marks d
