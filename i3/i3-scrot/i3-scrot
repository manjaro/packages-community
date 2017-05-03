#!/bin/sh
# /usr/bin/i3-scrot
#
# simple screenshot-script using scrot for manjaro-i3 by oberon@manjaro.org

_conf=$HOME/.config/i3-scrot.conf

if ! [ -f $_conf ]; then
	echo "scrot_dir=$(xdg-user-dir PICTURES)" > $_conf
fi

source $_conf

if ! [ -d $scrot_dir ]; then
	mkdir -p $scrot_dir
fi

if ! [[ -z "$2" ]]; then
    cmd="scrot -d $2"
else
    cmd='scrot'
fi

case "$1" in
	--desk|-d|$NULL)
		cd $scrot_dir
	        $cmd &&
		sleep 1 &&
		notify-send "screenshot has been saved in $scrot_dir"
		;;
	--window|-w)
		cd $scrot_dir
		$cmd -u &&
		sleep 1 &&
		notify-send "screenshot has been saved in $scrot_dir"
		;;
	--select|-s)
		cd $scrot_dir
		notify-send 'select an area for the screenshot' &
		scrot -s &&
		sleep 1 && notify-send "screenshot has been saved in $scrot_dir"
		;;
	--help|-h)
		echo "
available options:
-d | --desk    full screen
-w | --window  active window
-s | --select  selection
-h | --help    display this information

The -d or -w options can be used with a delay
by adding the number of seconds, like for example:
'i3-scrot -w 5'

Default option is 'full screen'.

The file destination can be set in ${_conf}.
Default is $scrot_dir
"
		;;
	*)
		echo "
== ! i3-scrot: missing or wrong argument ! ==

available options:
-d | --desk    full screen
-w | --window  active window
-s | --select  selection
-h | --help    display this information

Default option is 'full screen'.

The file destination can be set in ${_conf}.
Default is $scrot_dir
"

        exit 2
esac

exit 0
