
LOGS_DIR=$1
mkdir -p $LOGS_DIR

MASTER=$2
MASTER_ADDR=$3
REPO_DIR=$4

NAME="img2dataset"

docker run --rm --network=host \
  --name $NAME \
  --mount type=bind,source="$LOGS_DIR",target=/opt/spark/logs \
  -v /home:/home \
  -v /mnt/ceph:/mnt/ceph \
  --entrypoint=sh marianna13/spark-img2dataset \
    $REPO_DIR/start_cluster.sh $MASTER $MASTER_ADDR &

sleep 30
