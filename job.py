from img2dataset import download
import shutil
import os
from pyspark.sql import SparkSession 
import glob
import time
import argparse
from pyspark.sql.functions import col, udf
from pyspark.sql.types import StringType
import os.path


def spark_session(master_node, num_cores=16, mem_gb=256):
    """Build a spark session"""

    spark = (
        SparkSession.builder.config("spark.submit.deployMode", "client")
        .master(f"spark://{master_node}:7077")
        .config("spark.driver.port", "5678")
        .config("spark.executor.cores", "4")
        .config("spark.default.parallelism", num_cores) 
        # .config("spark.driver.blockManager.port", "6678")
        .config("spark.driver.host", master_node)
        .config("spark.driver.bindAddress", master_node)
        .config("spark.executor.memory", "4gb") # make sure to increase this if you're using more cores per executor
        .config("spark.driver.memory", "4G")
        # .config("spark.executor.memoryOverhead", "8GB")
        # .config("spark.task.maxFailures", "100")
        .appName("sparky")
        .getOrCreate()
    )

    return spark


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--master_node')
    parser.add_argument('--output_dir')
    parser.add_argument('--url_list')
    parser.add_argument('--num_proc')
    parser.add_argument('--caption_col')
    parser.add_argument('--url_col')

    args = parser.parse_args()

    master_node = args.master_node
    print(master_node)

    processes_count = args.num_proc

    output_dir = args.output_dir

    url_list = args.url_list

    spark = spark_session(master_node, processes_count, 256)
    
    s = time.time()
    print("starting download") 
    download(
        processes_count=processes_count,
        thread_count=32,
        # retries=0,
        url_list=url_list,
        output_folder=output_dir,
        output_format="webdataset",
        input_format="parquet",
        url_col=args.url_col,
        caption_col=args.caption_col,
        enable_wandb=False,
        number_sample_per_shard=5000,
        distributor="pyspark",
        compute_hash="md5",
        verify_hash=["md5", "md5"],
        subjob_size=processes_count,
        resize_mode="no"
    )

    print(time.time() - s)
    print("Job finished!")