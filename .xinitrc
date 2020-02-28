export EDITOR=vim
xrdb -load ~/.Xresources
compton --backend glx --paint-on-overlay --vsync opengl-swc --no-fading-openclose &
exec i3
