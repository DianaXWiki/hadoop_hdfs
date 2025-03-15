#!/bin/bash
set -e

echo "Checking if HDFS is formatted..."

# If the namenode directory does not contain the VERSION file, assume HDFS is not formatted.
if [ ! -f /opt/hadoop_data/namenode/current/VERSION ]; then
    echo "Formatting HDFS..."
    # Force-format if needed (use -force to bypass prompts)
    $HADOOP_HOME/bin/hdfs namenode -format -force
fi

echo "Starting HDFS daemons..."
# Start the DFS daemons (NameNode, DataNode, SecondaryNameNode)
$HADOOP_HOME/sbin/start-dfs.sh

echo "HDFS should now be running. Tailing logs..."
# Tail the logs so the container keeps running.
tail -f $HADOOP_HOME/logs/*

