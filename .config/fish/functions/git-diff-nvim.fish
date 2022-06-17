function git-diff-nvim \
    --description 'Opens the output of `git diff` in nvim, excluding any whitespace changes'
    nvim (git diff -w --word-diff-regex=[^[:space:]] $argv | psub)
end
