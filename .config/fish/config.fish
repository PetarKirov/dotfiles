source ~/.config/fish/aliases.fish

function get-path
    if type -q 'cygpath'
        cygpath -u $argv[1]
    else
        echo $argv[1]
    end
end

# Configure default editor:
for ED in nvim vim vi subl3 code nano
    if type $ED -q
        begin ; set -q EDITOR && set EDITOR $ED ; end || set -U EDITOR $ED
        break
    end
end

# Set-up variables for WSL:
if test -f /proc/sys/kernel/osrelease && cat /proc/sys/kernel/osrelease | grep -iq 'Microsoft'
    if apt list --installed 2>/dev/null | grep -q x11-apps
        set -U DISPLAY :0
    end
    set -U REPOS "/mnt/c/Users/$USER/Desktop/code/repos"
    alias start='/mnt/c/Windows/system32/cmd.exe /c start ""'
end

# Set-up variables for MSYS:
if uname -a | grep -iq msys
    set -U REPOS "/c/Users/$USER/Desktop/code/repos"
    set -p PATH "/c/Users/$USER/bin"

    # Chocolatey:
    set -p PATH '/c/ProgramData/chocolatey/bin'

    # nodejs, npm global:
    set -p PATH '/c/Program Files/nodejs'
    set -p PATH (get-path (npm bin --global 2>/dev/null))

    # Docker, kubectl:
    set -p PATH '/c/Program Files/Docker/Docker/Resources/bin'

    # dotnet:
    set -p PATH '/c/Program Files/dotnet'
else
    # Set-up variables for Linux:
    set -U REPOS "$HOME/code/repos"
    set -U TMPCODE "$HOME/code/tmp"
    set -p PATH "$REPOS/flutter/bin"
end

# Set-up the PATH:
which 'yarn' >/dev/null 2>&1 && set -p PATH (get-path (yarn global bin))
set -p PATH "$HOME/bin" "$HOME/.local/bin"

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

# If using fonts from this repo:
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular/complete
set -g theme_nerd_fonts yes
