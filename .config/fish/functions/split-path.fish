function split-path --argument-names 'path' -d 'Return filename, ext, and directory from the path'
    echo $path | sed 's/\(.*\)\/\(.*\)\.\(.*\)$/\2\n\3\n\1/'
end
