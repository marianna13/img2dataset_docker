# start ray cluster
PORT=6379
GLOBAL_RANK=$1
MASTER_ADDR=$2
MEM_IN_GB=$3
NUM_CPUS=`grep -c ^processor /proc/cpuinfo`

echo$PATH

echo $MASTER_ADDR
if [ "$GLOBAL_RANK" -eq 0 ]; then
    # print out some info 
    echo -e "MASTER ADDR: $MASTER_ADDR\tGLOBAL RANK: $GLOBAL_RANK\tCPUS PER TASK: $CPUS\tMEM PER NODE: $MEM_IN_GB"

    ray start --help
    CMD="
        ray start --head --port=$PORT --num-cpus=$NUM_CPUS --num-gpus=0 --memory=$MEM_IN_GB --block &"

    echo $CMD
    bash -c "$CMD"

    echo "Ray started"
fi

sleep 10

# if [ "$GLOBAL_RANK" -ne 0 ]; then
CMD="
    ray start --address=$MASTER_ADDR:$PORT --block &"

echo $CMD
bash -c "$CMD"

echo "Ray worker started"
# fi

sleep 1000000