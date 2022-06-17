function catn --argument-names start count file
    if not set -q file
        set file /dev/stdin
    end
    if test (string sub -s 1 -l 1 "$count") = '+'
        set end $count
        tail -n "+$start" $file | head -n (math "$end - $start + 1")
    else
        tail -n "+$start" $file | head -n $count
    end
end
