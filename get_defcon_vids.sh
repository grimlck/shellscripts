#!/bin/bash
# auth: grim
# date: 20120725
# desc: script to get all .m4v (DEFCON 7 to 19) files off the defcon rss feed

CURL="usr/bin/curl"
GREP="/usr/bin/grep"
DL_DIR="$HOME/DEFCON"
LINKLIST="$DL_DIR/linklist.txt"

# get the rss
# note: since there are just video available for DEFCON 7 to 19, we stay a little static here
test -d $DL_DIR && cd $DL_DIR || mkdir $DL_DIR && cd $DL_DIR 
for rss in {7..19};
do
    if [ ! -e defcon-$rss-video.rss ]
    then
        $CURL -O https://www.defcon.org/podcast/defcon-$rss-video.rss
    fi
done

# extract urls to the .m4v files and write to a file called linklist.txt in the download directory
if [ ! -e $LINKLIST ]
then
    for rss_file in $(ls $DL_DIR/*);
    do 
        $GREP -o -E "https://.*\.m4v" $rss_file >> $LINKLIST;
    done
fi

echo "Do you want to download every video of DEFCON 7 to 19 (y/n)?"
echo "Make sure you have enough disk space!"
read -n 1 choice
case $choice in
    y|Y)
        for m4vlink in $LINKLIST;
        do
            $CURL -O $m4vlink;
        done
        ;;
    n|N)
        echo "No videos downloaded."
        ;;
    *)
        echo "Did not recognize character."
        ;; 

esac

exit 0
