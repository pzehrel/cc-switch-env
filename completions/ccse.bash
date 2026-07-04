# cc-switch-env bash completion

_ccse_completion() {
  local cur prev providers
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  providers=$(ccenv list 2>/dev/null)

  case $COMP_CWORD in
    1)
      COMPREPLY=($(compgen -W "ls current default $providers" -- "$cur"))
      ;;
    2)
      if [ "$prev" = "default" ]; then
        COMPREPLY=($(compgen -W "-d $providers" -- "$cur"))
      fi
      ;;
  esac
}

complete -F _ccse_completion ccse
