MASTER_ADDR=$1
NAME="img2dataset"
SCRIPT="job.py"
URL_LIST=$2
OUTPUT_DIR=$3
NUM_CORES=$4
URL_COL=$5
CAPTION_COL=$6
REPO_DIR=$7
SCRIPT=$REPO_DIR/$SCRIPT

docker exec $NAME \
    python $SCRIPT \
    --master_node $MASTER_ADDR \
    --num_proc $NUM_CORES \
    --url_col "url" \
    --caption_col "caption" \
    --output_dir $OUTPUT_DIR \
    --url_list $URL_LIST
