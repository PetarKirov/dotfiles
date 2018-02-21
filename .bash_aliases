case `uname -s` in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN: `uname -s`"
esac

# Git specific aliases:
alias gs='git status'

alias gsh='git show'
alias gshr='git show --word-diff-regex=.'

alias gd='git diff'
alias gdr='git diff --word-diff-regex=.'

alias gdc='git diff --cached'
alias gdcr='git diff --cached --word-diff-regex=.'

alias ga='git add'
alias gap='git add -p'

alias gai='git add --intent-to-add'
alias gaia='git add --intent-to-add --all'

alias gco='git checkout'
alias gcb='git checkout -b'

alias gstaki='git stash --keep-index'

alias gspu='git stash && git status'
alias gspo='git stash pop'

alias gmvb='git branch --move'

# List
alias l='ls -la'

# Safe remove git branch
function grmbr {
    set -euo pipefail
    git checkout master \
    && git pull upstream master --ff-only \
    && git diff --quiet $1 \
    && git checkout $1 \
    && git rebase master \
    && git checkout master \
    && git branch -d $1
}

# Google Chrome aliases:
alias igchr='google-chrome --incognito & disown'

# Platform-specific aliases:
if [ "${machine}" == "MinGw" ]; then

    # Sublime Text 3
    alias subl='/c/Program\ Files/Sublime\ Text\ 3/subl.exe'
    expl() { explorer `cygpath -w $1`; }

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    alias igchr='google-chrome --incognito & disown'
fi
