# Basic abbreviations
abbr -a l 'ls -lah'
abbr -a p 'pushd'
abbr -a po 'popd'

# Check if a given name looks like a text file name.
#
# For example: 'smth.txt', '.gitconfig', 'Dockerfile'.
# 'abc.' and 'abc' are not considered file names.
# Of course, all of the above are valid names of
# both files and dirs, but this function uses a
# different heuristic of what a "text file name" is.
function looks-like-file --argument-names name
    string match -qr '^.*\..+$' "$name" \
        || string match -qr '^.*file$' "$name"
end

# Creates a text file or dir (see `looks-like-file`
# for the distinction between the two) and opens
# the file or goes inside the dir.
function mk --argument-names path
    if looks-like-file (basename "$path")
        set path (readlink -m "$path")
        set dir (dirname "$path")
        mkdir -p "$dir"
        pushd "$dir"
        $EDITOR "$path"
    else
        mkdir -p "$path"
        pushd "$path"
    end
end

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
abbr -a gai git add --intent-to-add

abbr -a gcm git commit
abbr -a gcma git commit --amend --no-edit

abbr -a gps git push -u '(git-default-remote)' HEAD
abbr -a gpf git push --force

function gaw --description 'Stages files specified in `$argv`, excluding their whitepace changes'
    git diff -U0 -w --no-color $argv | git apply --cached --ignore-whitespace --unidiff-zero -
end

abbr -a gco git checkout
abbr -a gcb git checkout -b

abbr -a gstaki git stash --keep-index --include-untracked

abbr -a gspo git stash pop
abbr -a gspu 'git stash --include-untracked; and git status'

abbr -a gbr git branch -a

abbr -a glg git log
abbr -a gl git lg

abbr -a grb git rebase
abbr -a grbc git rebase --continue
abbr -a grbi git rebase -i

abbr -a gchp git cherry-pick
abbr -a gchpc git cherry-pick --continue

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
    test -n "$feature_branch"; or set feature_branch (git branch --show-current)
    test -n "$master_branch"; or begin; echo '`$master_branch` not set'; return 1; end
    test -n "$remote"; or set remote upstream
    if git remote -v | grep -q '^me';
        set origin 'me'
    else if git remote -v | grep -q '^origin';
        set origin 'origin'
    else
        set origin $remote
    end
    echo "Updating '$master_branch' from '$remote' and deleting '$feature_branch' if '$origin/$feature_branch' was deleted"
    false
    git fetch --multiple --prune $remote $origin
    and git checkout $master_branch
    and git merge --ff-only $remote/$master_branch
    and git branch -d $feature_branch
    or begin
        git checkout $feature_branch
        git rebase $master_branch
        git checkout $master_branch
        git branch -d $feature_branch
    end
end

# ----- Direnv: -----
abbr -a dea direnv allow .
abbr -a ded direnv deny .

# ----- Docker: -----
function docker-pull-run --argument-names container_name image_name
    docker kill $container_name; or true
    docker pull $image_name
    and docker run -p 3000:80 --rm -d --name $container_name $image_name
end

function docker-kill-one
    test (docker ps | tail -n +2 | wc -l) -eq 1 \
        && docker kill (docker ps | tail -n +2 | awk '{print $1}') \
        || true
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
