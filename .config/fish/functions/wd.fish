function wd --argument-names file1 file2
    git diff --no-index \
        --word-diff-regex='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+' \
        -- $file1 $file2
end
