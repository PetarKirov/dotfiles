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

abbr -a gco git checkout
abbr -a gcb git checkout -b

abbr -a gstaki git stash --keep-index

abbr -a gspo  git stash pop 
alias gspu='git stash; and git status'

# Safe remove git branch
function grmbr
    git checkout master
    and git pull upstream master --ff-only
    and git diff --quiet $argv[1]
    and git checkout $argv[1]
    and git rebase master
    and git checkout master
    and git branch -d $argv[1]
end

# Google Chrome aliases:
alias igchr='google-chrome --incognito & disown'
