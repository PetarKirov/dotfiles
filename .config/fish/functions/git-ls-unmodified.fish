function git-ls-unmodified
    echo "Args: $argv"
    git ls-files --full-name | grep -v (git diff --name-only $argv[1])
end
