KEY=$1


MOUNT_DIR=$2
LOCAL_DIR=$3
USER=$4
HOST=$5

mkdir -p $LOCAL_DIR


sshfs -o allow_other,reconnect,auto_cache \
        -o IdentityFile=$KEY $USER@$HOST:$MOUNT_DIR $LOCAL_DIR
