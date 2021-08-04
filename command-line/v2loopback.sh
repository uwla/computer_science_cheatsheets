# list device supported formats
ffmpeg -f v4l2 -list_formats all -i /dev/video7

# video
ffmpeg -re -i video.mp4 -map 0:v -f v4l2 /dev/video2

# webcam from /dev/video0 to v4l2 virtual device in /dev/video7
ffmpeg -video_size 640x480 -framerate 30 -re -i /dev/video0 \
  -vf foobar -pix_fmt yuyv422 -video_size 640x480 -f v4l2 /dev/video7

# Greenscreen / chroma key / replace background
# see https://askubuntu.com/questions/881305/is-there-any-way-ffmpeg-send-video-to-dev-video0-on-ubuntu
ffmpeg -re -i ~/Images/abaporu.jpg -f v4l2 -i /dev/video0 -s 640x480 \
  -filter_complex "[1]chromakey=color=#326964:similarity=0.063:blend=0.02[fg];[0][fg]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:format=auto,format=yuyv422" \
  -f v4l2 /dev/video7

# share screen
ffmpeg -f x11grab -r 12 -s 2560x1080 -i :0.0+0,0 -vcodec rawvideo \
  -pix_fmt yuyv422 -threads 0 -f v4l2 -vf 'scale=640:480' /dev/video7

# mirror share screen
ffmpeg -f x11grab -r 12 -s 2560x1080 -i :0.0+0,0 -vcodec rawvideo \
  -pix_fmt yuyv422 -threads 0 -f v4l2 -filter_complex 'scale=640:480,hflip' /dev/video7

# edgedetect with text HELP written
ffmpeg -f v4l2 -i /dev/video0 -pix_fmt yuyv422 \
  -filter_complex 'scale=640:480,edgedetect=mode=colormix,drawtext=text='HELP':fontsize=24:fontcolor=white:font=Arial:x=w/2-tw/2:y=h/2-th/2,hflip' -f v4l2 /dev/video7

# celular automata on virtual device /dev/video7
ffmpeg -f lavfi -i cellauto=s=640x480:rule=193 -pix_fmt yuyv422 -f v4l2 /dev/video7

# mandelbrot set on virtual device /dev/video7
ffmpeg -f lavfi -i mandelbrot=s=640x480 -pix_fmt yuyv422 -f v4l2 /dev/video7

# watch webcam mpv ; mplayer

# mpv av://v4l2:/dev/video7
# mplayer tv://
# ffmpeg /dev/video7
