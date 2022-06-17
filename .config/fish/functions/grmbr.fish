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
