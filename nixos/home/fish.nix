{
  config,
  pkgs,
  omf-bobthefish,
  ...
}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fish-theme-bobthefish";
        src = omf-bobthefish;
      }
    ];
    interactiveShellInit = ''
      # bobthefish theme settings:
      set -g theme_newline_cursor yes
      set -g theme_date_format "+%H:%M:%S %F (%a)"
      set -g theme_color_scheme dark
      set -g theme_display_vi yes
      set -g theme_display_nix yes
      set -g theme_use_abbreviated_branch_name no
      set -g theme_display_git_master_branch yes
      set -g theme_prompt_prefix   '╭─'
      set -g theme_newline_prompt ' ╰─➤ '
      set -g theme_nerd_fonts yes

      set -g theme_display_node yes
    '';
    shellAbbrs = {
      # Basic
      l = "ls -lah";
      p = "pushd";
      po = "popd";

      # Direnv
      dea = "direnv allow .";
      ded = "direnv deny .";

      # Git
      gs = "git status";

      gsh = "git show";
      gshr = "git show --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\"";

      gd = "git diff";
      gdr = "git diff --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\"";

      gdc = "git diff --staged";
      gdcr = "git diff --staged --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\"";

      ga = "git add";
      gap = "git add -p";
      gau = "git add -u";
      gai = "git add --intent-to-add";

      gcm = "git commit -m";
      gcma = "git commit --amend --no-edit";

      gps = "git push -u (git-default-remote) HEAD";
      gpf = "git push --force";

      gco = "git checkout";
      gcb = "git checkout -b";

      gstaki = "git stash --keep-index --include-untracked";

      gspo = "git stash pop";
      gspu = "git stash --include-untracked; and git status";

      gbr = "git branch -a";

      glg = "git log";
      gl = "git lg";

      grb = "git rebase";
      grbc = "git rebase --continue";
      grbi = "git rebase -i";

      gchp = "git cherry-pick";
      gchpc = "git cherry-pick --continue";

      # Google Chrome aliases:
      igchr = "google-chrome --incognito & disown";
    };
  };
}