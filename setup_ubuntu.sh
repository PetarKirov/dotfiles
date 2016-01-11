# Enable i386:
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
# Maybe: sudo apt-get -f install

# Install Google Chrome:
# 1) Add Key
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# 2) Add Repo
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
# 3) update & install
sudo apt-get update
sudo apt-get install google-chrome-stable

# 1) Install dependencies
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties

# Install Sublime-Text 3
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer

# Add Package Control to Sublime-Text 3
# 1) Start Sublime-Text 3 and do ctrl+`
# 2) Enter:
	import urllib.request,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

# Fontconfig for Powerline fonts
# http://powerline.readthedocs.org/en/master/installation/linux.html
# Needed for https://github.com/bling/vim-airline
mkdir -p ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d/
cd Downloads
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Install VIM
sudo apt-get install vim ctags vim-doc vim-scripts

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# EditorConfig
sudo apt-get install editorconfig
# Add EditorConfig to Vim:
# Plugin 'editorconfig/editorconfig-vim'

# Copy .vimrc
cp scripts/.vimrc ~/.vimrc

# ==== Do a :PluginInstall in vim ====

# Install vim-jade plugin and add support for vibe.d diet templates
cd ~/.vim/bundle
[ -e vim-jade ] || git clone https://github.com/digitaltoad/vim-jade
cd vim-jade/ftdetect
grep -q '\*.dt' jade.vim || echo 'autocmd BufNewFile,BufReadPost *.dt set filetype=jade' >> jade.vim

# SDL2 (comes with alot of backage :( )
sudo apt-get install libsdl2-dev

# FreeGlut - for OpenGL (comes with alot of backagsudo apt-get install freeglut3-deve, when libsdl2-dev is not installed :( )
sudo apt-get install freeglut3-dev

# Super fast way of getting DMD
curl -fsSLO https://github.com/MartinNowak/installer/raw/install_script/script/install.sh && bash install.sh dmd && rm install.sh

# Old way of getting DMD and DUB
# Download and install dmd
# cd ~/Downloads
# wget http://downloads.dlang.org/releases/2.x/2.069.0/dmd_2.069.0-0_amd64.deb
# sudo dpkg -i dmd_2.069.0-0_amd64.deb

# Download and install dub
# wget http://code.dlang.org/files/dub-0.9.24-linux-x86_64.tar.gz
# tar -zxvf dub-0.9.24-linux-x86_64.tar.gz
# sudo mv dub /usr/bin/dub


# Install Ruby:
# 1) set-up rbenv
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

# 2) Setup ruby-build
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.2.2
rbenv global 2.2.2
ruby -v

# Install Mono
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
sudo apt-get update
sudo apt-get install mono-devel 
# Optional: sudo apt-get install mono-complete
# Install MonoDevelop
sudo apt-get install monodevelop

# Arc-theme and vertex icons:
# arc-theme
cd ~/Downloads
wget http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_15.04/all/arc-theme_1443869242.15936ec_all.deb
sudo dpkg -i arc-theme_1443869242.15936ec_all.deb

# vertex icons:
# First install Moka icons
sudo add-apt-repository ppa:moka/stable
sudo apt-get update && sudo apt-get install moka-icon-theme

# Or if this doesn't work:
cd ~/Downloads
git clone https://github.com/moka-project/moka-icon-theme
cd moka-icon-theme
cp -Rv Moka ~/.icons/

cd ~ && mkdir .icons/ && cd .icons/
git clone https://github.com/horst3180/Vertex-Icons

# download theme (http://www.noobslab.com/2014/04/macbuntu-1404-pack-is-released.html)
sudo apt-get install unity-tweak-tool
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install mac-ithemes-v3
sudo apt-get install mac-icons-v3

sudo apt-get install gpick

# Init Workspace
cd && mkdir dev && cd ~/dev
git clone https://github.com/ZombineDev/Chess2RT.git
cd Chess2RT
git checkout sdl-scene-format

cd ~/dev
git clone https://github.com/anrieff/trinity.git
cd trinity
mv trinity-linux.cbp trinity.cbp
rm trinity-win32.cbp


# SDL1 and OpenEXR
sudo apt-get install libsdl-dev
sudo apt-get install libopenexr-dev

# SDL2 v2.0.3
sudo add-apt-repository ppa:zoogie/sdl2-snapshots
sudo apt-get install libsdl2-dev=2.0.3+z4~20140315-8621-1ppa1trusty1

# Enable zRam (http://askubuntu.com/questions/174579/how-do-i-use-zram)
sudo apt-get install zram-config
