function git-init --argument-names language
    git init
    if not test -f .gitignore; and test -n "$language"
      wget -q -O .gitignore https://raw.githubusercontent.com/github/gitignore/master/{$language}.gitignore
    end
    if not test -f .editorconfig
      wget -q -O .editorconfig https://raw.githubusercontent.com/PetarKirov/dotfiles/master/.editorconfig
    end
end
