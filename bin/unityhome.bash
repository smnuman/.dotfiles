#!/bin/bash
# Collected from: http://askubuntu.com/a/43150/176470
# tabsize: 4, encoding: utf8
#
# © 2011 con-f-use@gmx.net. Use permitted under MIT license:
#     http://www.opensource.org/licenses/mit-license.php
# 
# CONTRIBUTORS: Chris Druif <cyber.druif@gmail.com>
#               Scott Severance <http://www.scottseverance.us/>
#               jacopoL <jacopo.jl@gmail.com>
# 
# This script updates the unity quicklist menu for nautilus to contain the user
# bookmarks. The updates will have efect after unity is restarted (either on
# the next login or by invoking 'unity --replace').

# location of template and unity bar launchers
nautempl="/usr/share/applications/nautilus-home.desktop"
target="$HOME/.local/share/applications/nautilus-home.desktop"
bookmarks="$HOME/.gtk-bookmarks"

# backup if file already exists
if [ -e "$target" ]; then
    echo "Creating backup of: $target."
    mv -n "$target" "$target.bak"
fi

# copy template
cp "$nautempl" "$target"

if ! grep -q 'OnlyShowIn=.*Unity' "$target"; then # add only if not already present
    sed -i "s/\(OnlyShowIn=.*\)/\1Unity;/" "$target"
fi

# due to a bug in Unity (Ubuntu 11.10+) we will have to completely remove the OnlyShowIn line:
# https://bugs.launchpad.net/ubuntu/+source/unity/+bug/842257/comments/6
sed -i '/^OnlyShowIn=/d' "$target"

if ! grep -q 'X-Ayatana-Desktop-Shortcuts=' "$target"; then # add only if not already present
    echo -e "\nX-Ayatana-Desktop-Shortcuts=\n" >> "$target"
else
    echo >> "$target"
fi

bmcount=0
while read bmline; do
    bmcount=$(($bmcount+1))     # number of current bookmark
    bmname=${bmline#*\ }        # name of the bookmark
    bmpath=${bmline%%\ *}       # path the bookmark leads to
    # deal with bookmarks that have no name
    if [ "$bmname" = "$bmpath" ]; then
        bmname=${bmpath##*/}
    fi
    # fix spaces in names and paths
    bmname="$(echo "$bmname" | sed 's/%20/ /g')"
    bmpath="$(echo "$bmpath" | sed 's/%20/ /g')"
    # fix accents in names and paths (for french users)
    bmname="$(echo "$bmname" | python -c 'import sys,urllib;sys.stdout.write(urllib.unquote(sys.stdin.read()))')"
    bmpath="$(echo "$bmpath" | python -c 'import sys,urllib;sys.stdout.write(urllib.unquote(sys.stdin.read()))')"
    # extend shortcut list with current bookmark, prepending a ; if needed
    sed -i "s/\(X-Ayatana-Desktop-Shortcuts=\(.*;$\|$\)\)/\1Scg${bmcount};/
            t
            s/\(X-Ayatana-Desktop-Shortcuts=.*\)/\1;Scg${bmcount};/" "$target"
    # write bookmark information
    if [ "file://$HOME" != "$bmpath" ]; then
    cat - >> "$target" <<EOF

[Scg$bmcount Shortcut Group]
Name=$bmname
Exec=nautilus "$bmpath"
TargetEnvironment=Unity
EOF
    fi
done < "$bookmarks"

# Add a root file manager entry
sed -i "s/\(X-Ayatana-Desktop-Shortcuts=.*\)/\1RootFM;/" "$target"
cat - >> "$target" <<EOF

[RootFM Shortcut Group]
Name=Root
Exec=gksudo nautilus
TargetEnvironment=Unity
EOF

exit 0
