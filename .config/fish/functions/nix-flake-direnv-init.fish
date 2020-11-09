function nix-flake-direnv-init
    set pwd $PWD
    echo "[>] Initializing nix flake project in '$pwd'"

    __ensure_cmd_exists grep
    __ensure_cmd_exists git
    __ensure_cmd_exists direnv
    __ensure_cmd_exists wget
    __ensure_cmd_exists nix

    if not nix flake --help >/dev/null 2>&1
        echo "[!] Nix flake support is not enabled."
        echo "[!] Please check: https://nixos.wiki/wiki/Flakes#Installing_flakes"
        exit 1
    end

    # Ensure .direnv/.gitkeep exists
    set gitkeep $pwd/.direnv/.gitkeep
    if not test -f $gitkeep
        mkdir (dirname $gitkeep)
        touch $gitkeep
        git add $gitkeep
    end

    # Ensure .envrc exists
    set envrc $pwd/.envrc
    if not test -f $envrc
        wget -q -O $envrc https://raw.githubusercontent.com/PetarKirov/dotfiles/master/.envrc
        git add $envrc
    end

    # Ensure that `result` and `.direnv/ is in `.gitignore`
    __append_to_gitignore 'result' 'Nix build output'
    __append_to_gitignore '.direnv/' 'direnv temporary files'
    git add .gitignore

    nix flake init
    git add flake.nix
end

function __ensure_cmd_exists --argument-names cmd
    if not type -q $cmd
        echo "[!] `$cmd` command not found."
        echo "[!] Please ensure that it is installed and available in \$PATH."
        exit 1
    end
end

function __append_to_gitignore --argument-names pattern comment
    if not grep -q "^$pattern\$" .gitignore
        echo "[>] Adding '$pattern' to .gitignore"
        echo -e "\n# $comment\n$pattern" >> .gitignore
    end
end
