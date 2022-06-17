function gcat --argument-names start_line end_line
    if test (count $argv) -gt 2
        git diff -U0 $argv[3..-1] | sed -r "s/^([^-+ ]*)[-+ ]/\\1/" | catn $start_line +$end_line
    else
        git diff -U0 HEAD~ HEAD | sed -r "s/^([^-+ ]*)[-+ ]/\\1/" | catn $start_line +$end_line
    end
end
