# Creates a text file or dir (see `looks-like-file`
# for the distinction between the two) and opens
# the file or goes inside the dir.
function mk --argument-names path
    if looks-like-file (basename "$path")
        set path (readlink -m "$path")
        set dir (dirname "$path")
        mkdir -p "$dir"
        pushd "$dir"
        $EDITOR "$path"
    else
        mkdir -p "$path"
        pushd "$path"
    end
end
