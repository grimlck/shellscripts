# This is a collection of shell scripts I've wriiten over the time.
## get_defcon_vid.sh
This script fetched the RSS files from <https://media.defcon.org/>, extracts the urls to the .m4v files, writes them to a list and if you want downloads them.
Since there are only videos of DEFCON 7 to 19 this script is a little static, so if anything changes (i.e. filenames), this script wont't work anymore.
I haven't testet the download yet, but I think it should work.

## backup_st3_settings.sh
Backup script for Sublime Text settings on Mac OSX. The script rsyncs ST settings (Packages and Installed Packages) from the local config folder to a Dropbox directory and vice versa.

Change **ST_BASE** and **DROPBOX** to match your Sublime Text and Dropbox folder.

        Usage: backup_st_settings.sh <backup|restore>

The idea is borrowed from <https://github.com/miohtama/ztanesh/blob/master/zsh-scripts/bin/setup-sync-sublime-over-dropbox.sh>
