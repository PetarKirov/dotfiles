function git-rebase-head
  set rebase_head (cat (git rev-parse --git-dir)/rebase-merge/head-name)
  set prefix 'refs/heads/'
  set prefix_len (string length $prefix)
  set rebase_head_len (string length $rebase_head)
  if test $rebase_head_len -le $prefix_len; or [ (string sub -s 1 -l $prefix_len $rebase_head) != $prefix ]
    echo "Error: '$rebase_head' does not start with '$prefix'"
    return 1
  end
  string sub -s (math "1 + $prefix_len") $rebase_head
end
