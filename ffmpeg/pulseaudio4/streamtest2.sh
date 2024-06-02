#!/bin/bash
# ffmpeg spectrum maker
action=$1
infile=$2
outfile=$3
upload_server="sftp://cloud"
upload_location="/home/master/videos/"
remote_command="youtube-upload --title=\"Remote_upload\" --privacy=\"private\" $upload_location$outfile"

#simple spectrum
filter1="showspectrum=s=1920x1080:slide=scroll:mode=combined:color=intensity:scale=cbrt:saturation=1:win_func=hann[tmp]"
#vertical mirror
filter2="[tmp]crop=iw:ih/2:0:ih/2-3,split[up][tmp];[tmp]vflip[down];[up][down]vstack[tmp]"
#horizontal mirror
filter3="[tmp]crop=iw/2:ih:iw/2:,split[left][tmp];[tmp]hflip[right];[left][right]hstack[tmp]"
#fisheye effect VERY SLOW!!! if used make change the size of the spectrum to (1920*11/10)x(1080*11/10) and use the crop filter below
filter4="[tmp]frei0r=filter_name=defish0r:filter_params=1.5|n[tmp]"
#make sure the resolution has the desired size
filter5="[tmp]crop=1920:1080"
#pass the stream to the output for ffplay
testpass="[tmp]copy[out0]"

vcodec="-codec:v libx264 -pix_fmt yuv420p -tune grain -crf 21 -preset medium -bf 2 -flags +cgop -r 25"
acodec="-codec:a libfdk_aac -b:a 128k -movflags +faststart"
#acodec="-codec:a copy"
extraflags="-movflags +faststart "

if [ "$action" = "test" ]
then
        ffplay -f lavfi "amovie=$infile,asplit[a][out1];[a]$filter1;$filter2;$filter3;$testpass"
fi

if [ "$action" = "make" ]
then
        ffmpeg -i "$infile" -filter_complex "[0:a]$filter1;$filter2;$filter3" -map [tmp] -map 0:a $vcodec $acodec $extraflags "$outfile"
fi
if [ "$action" = "upload" ]
then
        ffmpeg -i "$infile" -filter_complex "[0:a]$filter1;$filter2;$filter3" -map [tmp] -map 0:a $vcodec $acodec $extraflags "$upload_server$upload_location$outfile"
        ssh cloud $remote_command
fi
exit