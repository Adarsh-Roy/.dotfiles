# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prevent accidental file overwrites with >
set -o noclobber
# Safety guardrail
alias rm="rm -i"

# Backup
setopt EXTENDED_HISTORY
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# keep sensitive things out of .zshrc
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Appearance
ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# PATH extensions
export PATH="/usr/local/opt/node@22/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# Neovim
alias n='NVIM_APPNAME=nvim-self nvim'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Yazi
export EDITOR='env NVIM_APPNAME=nvim-self nvim'
export VISUAL="$EDITOR"
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Bare git repository for managing dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Personal
alias open-pro-notes='cd ~/Obsidian/Professional/ObsidianProfessionalVault/'

# Dragonfruit
alias alem='alembic --config "app_alembic.ini"'
alias open-df-services='cd ~/Desktop/DF_Repos/df-services/'
alias open-df-common='cd ~/Desktop/DF_Repos/df-common/'
alias open-transport-service='cd ~/Desktop/DF_Repos/transport-service/'
alias open-df-notes='cd ~/Obsidian/Dragonfruit/DragonfruitVault/'

alias rdfss='cd /Users/adarsh/Desktop/DF_Repos/df-services && \
  POSTGRES_URL=$POSTGRES_URL_STAGE \
  POSTGRES_USERNAME=$POSTGRES_USERNAME_STAGE \
  POSTGRES_PASSWORD=$POSTGRES_PASSWORD_STAGE \
  ANALYTICS_POSTGRES_URL=$ANALYTICS_POSTGRES_URL_STAGE \
  ANALYTICS_POSTGRES_USERNAME=$ANALYTICS_POSTGRES_USERNAME_STAGE \
  ANALYTICS_POSTGRES_PASSWORD=$ANALYTICS_POSTGRES_PASSWORD_STAGE \
  flask run'

alias rdfsl='cd /Users/adarsh/Desktop/DF_Repos/df-services && \
  POSTGRES_URL=$POSTGRES_URL_LOCAL \
  POSTGRES_USERNAME=$POSTGRES_USERNAME_LOCAL \
  POSTGRES_PASSWORD=$POSTGRES_PASSWORD_LOCAL \
  ANALYTICS_POSTGRES_URL=$ANALYTICS_POSTGRES_URL_LOCAL \
  ANALYTICS_POSTGRES_USERNAME=$ANALYTICS_POSTGRES_USERNAME_LOCAL \
  ANALYTICS_POSTGRES_PASSWORD=$ANALYTICS_POSTGRES_PASSWORD_LOCAL \
  flask run'

# zoxide
eval "$(zoxide init zsh)"
