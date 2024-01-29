function build -a cache -d "Build with Nix and push to Cachix"
    argparse --min-args=1 h/help c/cache= -- $argv
    or return
    set -l cache "$_flag_cache"
    if test -z "$cache"
      set cache "$CACHIX_CACHE"
    end
    if set -ql _flag_help; or test -z "$cache"
        echo "build [-h|--help] [-c|--cache] [FLAKE_REFs ...]"
        return 0
    end
    echo "Building"
    for attr in $argv
      echo "  * $attr"
    end
    echo "And pushing to cache: '$cache'"
    nom build -L --json --no-link --keep-going \
        $argv \
    | jq -r '.[] | .outputs.out' \
    | cachix push $cache
end
