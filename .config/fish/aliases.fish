# Git abbreviations and aliases:
abbr -a gs git status

abbr -a gsh git show
abbr -a gshr git show --word-diff-regex=.

abbr -a gd git diff
abbr -a gdr git diff --word-diff-regex=.

abbr -a gdc git diff --cached
abbr -a gdcr git diff --cached --word-diff-regex=.

abbr -a ga git add
abbr -a gap git add -p

abbr -a gstaki git stash --keep-index

abbr -a gspo  git stash pop 
alias gspu='git stash; and git status'

# Google Chrome aliases:
alias igchr='google-chrome --incognito & disown'
