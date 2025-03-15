# Use a base image with Java 17 installed
FROM openjdk:17-jdk-slim

# Install any additional Linux packages you might need (e.g. openssh-server for Hadoop if required)
RUN apt-get update && apt-get install -y \
    openssh-server \
    procps \
    net-tools \
 && rm -rf /var/lib/apt/lists/*

# Create a "hadoop" group and user
RUN groupadd -r hadoop && useradd -r -g hadoop hadoop

# Create a home directory for the hadoop user
RUN mkdir -p /home/hadoop
WORKDIR /home/hadoop

# Copy only the tarball into the container
COPY ../hadoop-dist/target/hadoop-3.5.0-SNAPSHOT /opt/hadoop_hdfs

# Create directories for HDFS data; these are used for the NameNode and DataNode storage.
# Adjust ownership and permissions so that the "hadoop" user can write to them.
USER root
RUN mkdir -p /opt/hadoop_data/namenode /opt/hadoop_data/datanode && \
    chown -R hadoop:hadoop /opt/hadoop_data
     
# Set environment variables needed for Hadoop.
ENV HADOOP_HOME=/opt/hadoop_hdfs
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Copy the entrypoint script into the container and make it executable.
COPY ./my_docker/entrypoint.sh /home/hadoop/entrypoint.sh
RUN chmod +x /home/hadoop/entrypoint.sh

# Expose the ports you need (e.g., 9000 for the NameNode RPC, 9870 for the web UI, etc.)
EXPOSE 9000 9870 9864 9866 9867

# Switch to the "hadoop" user
USER hadoop

# Use the entrypoint script as the container’s default command.
CMD ["/home/hadoop/entrypoint.sh"]

