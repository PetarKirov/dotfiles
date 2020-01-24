function svg-opt --argument-names input_file
    set input_file_ext_dir (split-path (realpath $input_file))
    set output_path $input_file_ext_dir[3]/$input_file_ext_dir[1]-opt.svg
    echo "Optimizing '$input_file' and saving it as '$output_path'"
    svgcleaner \
        --indent 2 \
        "$input_file" \
        "$output_path"
end
