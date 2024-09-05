#!/bin/bash

GLOBAL_RANK=$1
MASTER_ADDR=$2
MEM_IN_GB=$3

echo "Mem in GB start cluster: $MEM_IN_GB"


CPUS=`grep -c ^processor /proc/cpuinfo`
MEM=$((`grep MemTotal /proc/meminfo | awk '{print $2}'` / 1000)) # seems to be in MB
# export MASTER_ADDR=`hostname -s`
LOCAL_IP=$(hostname -I | awk '{print $1}')
LOCALDIR=/spark

# set some environment variables


export SPARK_MASTER="spark://$MASTER_ADDR:7077"
export SPARK_MASTER_HOST=$MASTER_ADDR
export SPARK_WORKER_DIR=$LOCALDIR/work
export SPARK_LOCAL_DIRS=$LOCALDIR/local
export SPARK_WORKER_LOG_DIR=$LOCALDIR/worker_logs

# set spark driver memory
conf_file=$SPARK_HOME/conf/spark-defaults.conf
# echo "spark.driver.memory ${MEM_IN_GB}g" >> $conf_file

# set DNS
# echo "nameserver 127.0.0.153" > /etc/resolv.conf


# setup the master node
echo $MASTER_ADDR
if [ "$GLOBAL_RANK" -eq 0 ]; then
    # print out some info 
    echo -e "MASTER ADDR: $MASTER_ADDR\tGLOBAL RANK: $GLOBAL_RANK\tCPUS PER TASK: $CPUS\tMEM PER NODE: $MEM"

    # then start the spark master node in the background
    ./sbin/start-master.sh -p 7077 -h $MASTER_ADDR
fi

sleep 10

# then start the spark worker node in the background
# MEM_IN_GB=$(($MEM / 1024))
# # take only 60% of the memory
# MEM_IN_GB=$(($MEM_IN_GB *  3/ 10))
# # concat a "G" to the end of the memory string
# MEM_IN_GB="$MEM_IN_GB"G
echo "MEM IN GB: $MEM_IN_GB"

./sbin/start-worker.sh -c $CPUS -m $MEM_IN_GB "spark://$MASTER_ADDR:7077"
echo "Hello from worker $GLOBAL_RANK"

sleep 10

if [ "$GLOBAL_RANK" -eq 0 ];
then
    # then start some script
    echo "hi"
fi

sleep 1000000