#!/usr/local/bin/zsh
# Script inspired by http://opensourcehacker.com/2012/05/24/sync-and-back-up-sublime-text-settings-and-plug-ins-using-dropbox-on-linux-and-osx/
# Usage: backup_st_settings.sh <backup|restore>

USAGE="$(basename $0) backup|restore"

DROPBOX="$HOME/Dropbox"
BACKUP_TARGET="$DROPBOX/Apps/Sublime Text 3"

ST_BASE="$HOME/Library/Application Support/Sublime Text 3"
ST_PACKAGES="$ST_BASE/Packages"
ST_INSTALLED_PACKAGES="$ST_BASE/Installed Packages"

# Create Dropbox target
test -d $BACKUP_TARGET || mkdir -p $BACKUP_TARGET

# Check if ST folders exists
if [ ! -d "$ST_PACKAGES" ]
then
    echo -e "$ST_PACKAGES does not exist\nLeaving."
    exit 1
fi

if [ ! "$ST_INSTALLED_PACKAGES" ]
then
    echo -n "$ST_INSTALLED_PACKAGES does not exist\nLeaving."
    exit 1
fi


case $1 in
[Bb]ackup)
    # rsync settings to Dropbox
    echo "rsyncing settings to Dropbox..."
    rsync -aud $ST_PACKAGES $ST_INSTALLED_PACKAGES $BACKUP_TARGET && echo "Done."
    ;;
[Rr]estore)
    # rsync settings from Dropbox
    if [ ! -d "$BACKUP_TARGET/Packages" ] && [ ! -d "$BACKUP_TARGET/Installed Packages" ]
    then
        echo -e "ST backup missing on Dropbox\nLeaving."
        exit 1
    fi

    echo "rsyncing settings to $ST_BASE"
    rsync -aud "$BACKUP_TARGET/Packages" "$BACKUP_TARGET/Installed Packages" "$ST_BASE" && echo "Done."
    ;;
*)
    echo "Usage: $USAGE"
    exit 0
    ;;
esac
