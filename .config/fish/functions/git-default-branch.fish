function git-default-branch
  set default_branches master main dev
  for branch in $default_branches
    if git rev-parse --verify $branch >/dev/null 2>&1
      echo $branch
      return 0
    end
  end
  return 1
end
