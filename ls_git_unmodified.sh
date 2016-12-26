ls_unchanged () {
    git ls-files --full-name | grep -v "$(git diff --name-only $1)"
}

ls_unchanged $1
