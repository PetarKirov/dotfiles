function git-init --argument-names language
    git init
    if not test -f .gitignore; and test -n "$language"
      wget -q -O .gitignore https://raw.githubusercontent.com/github/gitignore/master/{$language}.gitignore
      if test "$language" = 'Node' && type -q patch
          # Patch Yarn V2 section in Node.gitignore.
          # See https://yarnpkg.com/advanced/qa#which-files-should-be-gitignored
          # section and specifically "not using Zero-Installs".
          echo "\
--- .gitignore
+++ .gitignore
@@ -109,7 +109,7 @@

 # yarn v2

-.yarn/cache
-.yarn/unplugged
-.yarn/build-state.yml
+.yarn/*
+!.yarn/releases
+!.yarn/plugins
 .pnp.*" | patch .gitignore
      end
    end
    if not test -f .editorconfig
      wget -q -O .editorconfig https://raw.githubusercontent.com/PetarKirov/dotfiles/master/.editorconfig
    end
end
