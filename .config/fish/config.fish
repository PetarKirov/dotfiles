source ~/.config/fish/aliases.fish

# Configure default editor:
for ED in nvim vim vi subl3 code nano
    if type $ED -q
        set -U EDITOR $ED
        break
    end
end

# Set-up the PATH:
set -p PATH (yarn global bin)
set -p PATH "$HOME/bin"

# bobthefish theme settings:
set -g theme_newline_cursor yes
set -g theme_date_format "+%H:%M:%S %F (%a)"
set -g theme_color_scheme dark
set -g theme_display_vi yes
# If using fonts from this repo:
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular/complete
set -g theme_nerd_fonts yes
