xset -b
eval $(gpg-agent --daemon)
export EDITOR=emacsclient
xrdb -load ~/.Xresources
compton --backend glx --paint-on-overlay --vsync opengl-swc --no-fading-openclose &
exec i3
