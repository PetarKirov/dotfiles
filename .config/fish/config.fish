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
