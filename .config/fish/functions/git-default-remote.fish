function git-default-remote
  set default_branch (git-default-branch)
  git rev-parse --abbrev-ref --symbolic-full-name "$default_branch@{u}" \
    | grep --color=no -oP "(.*)(?=/$default_branch)"
end
