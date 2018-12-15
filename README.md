# dropbox
Dropbox

Not completed yet - need to run /tmp/entrypoint.sh after start

docker run \
       -it \
       --rm \
       --privileged \
       -v "${PWD}/dropbox_prog:/home/dropbox/.dropbox-dist" \
       -v "${PWD}/dropbox_config:/home/dropbox/.dropbox" \
       -v "${PWD}/dropbox_copy:/home/dropbox/Dropbox_copy" \
       -v "${PWD}/dropbox_mnt:/mnt" \
       martinjohn/dropbox
