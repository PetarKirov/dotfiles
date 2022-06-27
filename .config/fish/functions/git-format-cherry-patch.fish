function git-format-cherry-patch
    argparse 'output_dir=?' -- $argv
    or return
    set output_dir '.'
    if test -n "$_flag_output_dir"
        set output_dir $_flag_output_dir
    end
    set output_dir (realpath $output_dir)
    echo Saving (count $argv) 'patch(es)' to "'$output_dir'"
    for i in (seq (count $argv))
        git format-patch -1 --output-directory $output_dir --start-number=$i $argv[$i]
    end
end
