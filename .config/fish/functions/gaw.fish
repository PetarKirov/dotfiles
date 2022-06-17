function gaw --description 'Stages files specified in `$argv`, excluding their whitepace changes'
    git diff -U0 -w --no-color $argv | git apply --cached --ignore-whitespace --unidiff-zero -
end
