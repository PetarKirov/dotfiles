function git-init --argument-names language
    git init
    if not test -f .gitignore; and test -n "$language"
      wget -q -O .gitignore https://raw.githubusercontent.com/github/gitignore/master/{$language}.gitignore
    end
    if not test -f .editorconfig
      echo > .editorconfig "\
# EditorConfig file: http://EditorConfig.org
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 4
max_line_length = 80

[*.{yml,yaml,dart,js,jsx,ts,tsx,Dockerfile}]
indent_size = 2"
    end
end
