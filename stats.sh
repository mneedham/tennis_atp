check_memory_usage() {
    maxTime=${1:=30}

    start=$(date +%s)
    hasStarted=0
    while true; do
        if [ $(date +%s) -gt `expr ${start} + ${maxTime}` ]; then
            break;
        fi
        stats=$(docker stats --format '{{.Name}}\t{{.MemPerc}}\t{{.MemUsage}}' --no-stream)

        if [ -z "${stats}" ]; then
            if [ ${hasStarted} -eq 1 ]; then
                break;
            fi
            continue;
        fi
        hasStarted=1
        echo "$(date "+%Y-%m-%d %H:%M:%S")\t${stats}"
    done
}