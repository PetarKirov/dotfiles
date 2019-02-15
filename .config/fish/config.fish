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
        set -U EDITOR $ED
        break
    end
end

# Set-up variables for WSL:
if test -f /proc/sys/kernel/osrelease && cat /proc/sys/kernel/osrelease | grep -iq 'Microsoft'
    if apt list --installed 2>/dev/null | grep -q x11-apps
        set -U DISPLAY :0
    end
    set -U REPOS '/mnt/c/Users/Petar/Desktop/code/repos'
end

# Set-up variables for MSYS:
if uname -a | grep -iq msys
    set -p PATH '/c/Program Files/nodejs'
    set -p PATH (get-path (npm bin --global 2>/dev/null))
    set -U REPOS '/c/Users/Petar/Desktop/code/repos'
end

# Set-up the PATH:
set -p PATH (get-path (yarn global bin))
set -p PATH "$HOME/bin"

# bobthefish theme settings:
set -g theme_newline_cursor yes
set -g theme_date_format "+%H:%M:%S %F (%a)"
set -g theme_color_scheme dark
set -g theme_display_vi yes
# If using fonts from this repo:
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular/complete
set -g theme_nerd_fonts yes
