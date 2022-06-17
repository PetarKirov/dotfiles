# Check if a given name looks like a text file name.
#
# For example: 'smth.txt', '.gitconfig', 'Dockerfile'.
# 'abc.' and 'abc' are not considered file names.
# Of course, all of the above are valid names of
# both files and dirs, but this function uses a
# different heuristic of what a "text file name" is.
function looks-like-file --argument-names name
    string match -qr '^.*\..+$' "$name" \
        || string match -qr '^.*file$' "$name"
end
