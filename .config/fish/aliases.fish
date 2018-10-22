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

abbr -a gspo git stash pop
alias gspu='git stash; and git status'

abbr -a gbr git branch -a

abbr -a glg git log

abbr -a grb git rebase
abbr -a grbi git rebase -i

# Safe remove git branch
function grmbr --argument-names remote master_branch feature_branch
    test -n "$feature_branch"; or exit 1
    test -n "$master_branch"; or set master_branch master
    test -n "$remote"; or set remote upstream
    echo "Updating '$master_branch' from '$remote' and deleting '$feature_branch'"
    git fetch $remote --prune
    and git checkout $master_branch
    and git merge --ff-only $remote/$master_branch
    and git checkout $feature_branch
    and git rebase $master_branch
    and git checkout $master_branch
    and git branch -d $feature_branch
end

# Google Chrome aliases:
alias igchr='google-chrome --incognito & disown'
