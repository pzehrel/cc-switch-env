# cc-switch-env bash completion

_ccse_completion() {
  local cur prev providers aliases
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  providers=$(command ccse list --names 2>/dev/null)
  aliases=$(command ccse list --aliases 2>/dev/null)

  case $COMP_CWORD in
    1)
      COMPREPLY=($(compgen -W "ls current default $providers $aliases" -- "$cur"))
      ;;
    2)
      if [ "$prev" = "default" ]; then
        COMPREPLY=($(compgen -W "-d $providers $aliases" -- "$cur"))
      fi
      ;;
  esac
}

complete -F _ccse_completion ccse
