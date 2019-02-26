# Script to change video to animated gif
#
# Required software:
# $sudo apt-get install ffmpeg
#
# How to use:
# $./video2gif.sh arg1 arg2 arg3 arg4 arg5 arg6
# arg1 --> start time
# arg2 --> name of input video (mp4, etc)
# arg3 --> duration (second)
# arg4 --> number of frame per second
# arg5 --> frame size of output animated gif (640x360, etc)
# arg6 --> name of output animated gif (.gif)
#
# Example:
# $./video2gif.sh 0:00 challenge.mp4 5 15 640x360 challenge.gif
if ! [ -x "$(command -v ffmpeg)" ]; then
	echo "ffmpeg is not installed. Start to install ffmpeg ..."
	sudo apt-get install ffmpeg
else
	echo "ffmpeg is already installed. No need to install again."
fi
echo "-----------------"
echo "Start to change video to animated gif ..."
ffmpeg -ss $1 -i $2 -t $3 -an -r $4 -s $5 -f gif $6
