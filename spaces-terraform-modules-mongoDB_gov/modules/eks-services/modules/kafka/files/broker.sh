#!/bin/bash
DAEMON_PATH=/opt/kafka_2.13-2.7.1
PATH=$PATH:$DAEMON_PATH/bin

export KAFKA_HEAP_OPTS="-Xmx12g -Xms6g -XX:MetaspaceSize=96m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:G1HeapRegionSize=16M -XX:MinMetaspaceFreeRatio=50 -XX:MaxMetaspaceFreeRatio=80"
echo $1

case "$1" in
  start)
        # Start daemon.
        pid=`ps ax | grep 'kafka.Kafka' | grep -v grep | awk /'{print /$1}/'`
        if [ -n "$pid" ]
          then
          echo "Kafka is Running as PID: $pid"
          exit 1
        fi
        rm -rf /mnt/data/logs/broker.log
        echo "Starting Kafka";
        nohup $DAEMON_PATH/bin/kafka-server-start.sh $DAEMON_PATH/config/server.properties &> /mnt/data/logs/broker.log &
        tail -f /mnt/data/logs/broker.log
        ;;
  stop)
        echo "Shutting down Kafka";
        pid=`ps ax | grep 'kafka.Kafka' | grep -v grep | awk /'{print /$1}/'`
        if [ -n "$pid" ]
          then
          $DAEMON_PATH/bin/kafka-server-stop.sh
        else
          echo "Kafka was not Running"
        fi
        ;;
  status)
        pid=`ps ax | grep 'kafka.Kafka' | grep -v grep | awk /'{print /$1}/'`
        if [ -n "$pid" ]
          then
          echo "Kafka is Running as PID: $pid"
        else
          echo "Kafka is not Running"
        fi
        ;;
  *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
esac

exit 0