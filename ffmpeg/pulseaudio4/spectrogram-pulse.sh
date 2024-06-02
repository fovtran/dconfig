#!/bin/bash
# __AUTHOR__="dmc2022"
# __DATE__ = "2022-07-13"
trap "set +x" QUIT EXIT
#trap 'echo -ne "\e]0;$BASH_COMMAND\007"' DEBUG
set +x
stty -echoctl # hide ^C
trap 'die' SIGINT

test -x /bin/date || exit 100
test -x /usr/bin/ffmpeg || exit 100
test -x /usr/bin/sox || exit 100
test -x /usr/bin/sndfile-spectrogram || exit 100
test -x /usr/bin/mogrify || exit 100

TODO="
	review yuv444p for color rages
	etc"
USAGE="spectrogram.sh <test|record|replay|spectrogram|studio|playback>"

DATE=$(/bin/date +"%Y-%m-%d--%H-%M")
VIDFILE="/tmp/record-$DATE.mp4"
FILE1="/tmp/record-$DATE.mp3"
FILE2="/tmp/record-$DATE.wav"
OUT1='/tmp/output-sox'
OUT2='/tmp/output-sndfile'
ODIR="/tmp/"
opts="-hide_banner -fflags nobuffer -fflags discardcorrupt -flags low_delay -avioflags direct "

echo "Starting at $DATE"

function die(){
#   echo ${1:=Something terrible wrong happen}
	killall -SIGINT ffmpeg
	killall -SIGINT ffplay
   #... clean your trash
   exit 1
}

function startrecord {
	echo "Start recording"
	ffmpeg $opts -f alsa -i pulse -ac 2 -y -vn $FILE1
	echo "Finished recording $FILE1"
}

function replay {
	ffplay $opts-x 1436 -y 780 -autoexit $FILE1
}

function runspectrogram {
	#FILE1="$@"
	echo "Working the spectrograms"
	sox $FILE1 -n spectrogram -t $FILE1 -p 2 -S 5 -x 1440 -o "$OUT1.png"
	sndfile-spectrogram --dyn-range=120 $FILE2 1420 840 "$OUT2.png"
	#mogrify -strip -quality 90% -sampling-factor 4:4:4 -format jpg "$OUT1".png
	#mogrify -strip -quality 90% -sampling-factor 4:4:4 -format jpg "$OUT2".png
	#rm "$OUT1.png" "$OUT2.png"

	xview "$OUT1.png" &
	xview "$OUT2.png" &

	rm "$OUT1.jpg"
	rm "$OUT2.jpg"
}

function spectrogram {
	if [ -e $FILE1 ]; then
			runspectrogram
	else
		echo "$FILE1 does not exist."
		if [ -z $2 ]; then
			FILE1="$@"
			export FILE1
			echo "Graphing $FILE1"
			# exit -1
			ffmpeg $opts -y -i $FILE1 $FILE2
			runspectrogram $FILE1
		fi
	fi
}

function studiorecord {
	title="Studio recording - $DATE"
	genre="Studio recording"
	composer="dmc2022"
	album="Studio recordings 4"
	author="ManuCampos"
	artists="Diego, others"
	comment="Recorded on $DATE"
	ffmpeg -y -f alsa -i pulse -f x11grab -video_size 1440x900 -i ":0.0" -r 10 -vcodec libx264 -pix_fmt yuv420p \
		-metadata "title=$title" \
		-metadata "genre=$genre" \
		-metadata "composer=$composer" \
		-metadata "album=$album" \
		-metadata "author=$author" \
		-metadata "album_artist=$artists" \
		-metadata "comment=$comment" $VIDFILE

	echo "Finished recording $VIDFILE"
}

function playback {
	VIDFILE="/tmp/record-$DATE.mp4"
	#ffplay $opts-x 1420 -y 880 -autoexit $VIDFILE
	ffplay $opts-x 1440 -y 900 -autoexit $VIDFILE
	#ffplay -fflags nobuffer -fflags discardcorrupt -flags low_delay -framedrop -avioflags direct /tmp/record-2022-07-13--05-00.mp4 
}

case "$1" in
	"test")
	Message="All is quiet."
	echo $Message	
	echo $TODO
	;;
	"replay")
	Message="Playing recorded $FILE1."
		echo $Message
		replay
	;;
	"record")
		Message="Audio record $FILE1 from pulseaudio."
		echo $Message	
		startrecord
		;;
	"spectrogram")
		Message="Spectrogram...."
		echo $Message	
		spectrogram $2
		;;
	"playback")
		Message="Playback."
		echo $Message	
		playback
		;;
	"studio")
	Message="Studio record $FILE1."
		echo $Message	
		studiorecord
	;;
	*)
	Message="command not understood..."
		echo $USAGE
		exit 1
	;;
esac

[ ! -z $ARG ] || die "whatever is not available"