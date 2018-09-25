function enforce
    if not test $argv[1..-2]
        echo $argv[-1] 1>&2
        exit 42
    end
end
