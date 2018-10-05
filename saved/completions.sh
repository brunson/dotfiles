# Bash completation for application

_saved_marks()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we'll complete.
    #
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
