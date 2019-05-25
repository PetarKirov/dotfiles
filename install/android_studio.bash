#!/usr/bin/env bash

set -euxo pipefail

android_studio_path="/usr/local/android-studio"
system_app_folder="/usr/share/applications"

cat > "$system_app_folder/android_studio.desktop" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon=$android_studio_path/bin/studio.png
Exec=sh $android_studio_path/bin/studio.sh
Name=Android Studio
EOL
