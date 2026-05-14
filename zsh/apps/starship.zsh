# Starship prompt
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select ""
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
