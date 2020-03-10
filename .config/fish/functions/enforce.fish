function enforce --argument-names input parameter_name
    if test -z "$input"
        if test -z "$parameter_name"
            echo "Required parameter missing." 1>&2
        else
            echo "Required parameter `$parameter_name` missing." 1>&2
        end
        return 1
    else
        echo "$input"
    end
end
