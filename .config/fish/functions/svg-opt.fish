function svg-opt
    argparse 'i-inline' 'f-input=' -- $argv
    set -l input_file (enforce "$_flag_input" "--input"); or return
    set -l inline $_flag_inline
    if test -z "$inline"
        set input_file_ext_dir (split-path (realpath $input_file))
        set output_path $input_file_ext_dir[3]/$input_file_ext_dir[1]-opt.svg
    else
        set output_path $input_file
    end
    echo "Optimizing '$input_file' and saving it as '$output_path'"
    svgcleaner \
        --indent 2 \
        "$input_file" \
        "$output_path"
end
