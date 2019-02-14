# Basic abbreviations
abbr -a l 'ls -la'

# ----- File Diff: -----
function wd --argument-names file1 file2
    git diff --no-index \
        --word-diff-regex='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+' \
        -- $file1 $file2
end

# ----- Git: -----
abbr -a gs git status

abbr -a gsh git show
abbr -a gshr git show '--color-words=\'[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\''

abbr -a gd git diff
abbr -a gdr git diff '--color-words=\'[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\''

abbr -a gdc git diff --cached
abbr -a gdcr git diff --cached '--color-words=\'[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\''

abbr -a ga git add
abbr -a gap git add -p
abbr -a gau git add -u

abbr -a gcm git commit
abbr -a gcma git commit --amend --no-edit

abbr -a gps git push
abbr -a gpf git push --force

function gaw --description 'Stages files specified in `$argv`, excluding their whitepace changes'
    git diff -U0 -w --no-color $argv | git apply --cached --ignore-whitespace --unidiff-zero -
end

abbr -a gco git checkout
abbr -a gcb git checkout -b

abbr -a gstaki git stash --keep-index

abbr -a gspo git stash pop
alias gspu='git stash; and git status'

abbr -a gbr git branch -a

abbr -a glg git log
abbr -a gl git lg

abbr -a grb git rebase
abbr -a grbi git rebase -i

function git-diff-nvim \
    --description 'Opens the output of `git diff` in nvim, excluding any whitespace changes'
    nvim (git diff -w --word-diff-regex=[^[:space:]] $argv | psub)
end

function git-ls-unmodified
    echo "Args: $argv"
    git ls-files --full-name | grep -v (git diff --name-only $argv[1])
end

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


# ----- Docker: -----
function docker-pull-run --argument-names container_name image_name
    docker kill $container_name; or true
    docker pull $image_name
    and docker run -p 3000:80 --rm -d --name $container_name $image_name
end

function catn --argument-names start count file
    if not set -q file
        set file /dev/stdin
    end
    if test (string sub -s 1 -l 1 "$count") = '+'
        set end $count
        tail -n "+$start" $file | head -n (math "$end - $start + 1")
    else
        tail -n "+$start" $file | head -n $count
    end
end

function gcat --argument-names start_line end_line
    if test (count $argv) -gt 2
        git diff -U0 $argv[3..-1] | sed -r "s/^([^-+ ]*)[-+ ]/\\1/" | catn $start_line +$end_line
    else
        git diff -U0 HEAD~ HEAD | sed -r "s/^([^-+ ]*)[-+ ]/\\1/" | catn $start_line +$end_line
    end
end

# Google Chrome aliases:
alias igchr='google-chrome --incognito & disown'