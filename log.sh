#!/bin/bash

interval=5
run_name="program_run"
verbose=false

# Function to write to the log file
write_to_log() {
    echo "$1" | tee -a "$2"
    if [ "$verbose" = true ]; then
        echo "$1"
    fi
}

# Parse command-line options
while getopts ":n:r:v" opt; do
    case $opt in
        n)
            interval=$OPTARG
            ;;
        r)
            run_name=$OPTARG
            ;;
        v)
            verbose=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

# Get the command to execute
command="$@"

# Generate log file names

time_file = ${run_name}_time.txt
gpu_log_file="${run_name}_gpu_utilization.txt"
cpu_log_file="${run_name}_cpu_stats.txt"
sensors_log_file="${run_name}_sensors.txt"

# Capture start time
start_time=$(date +"%Y-%m-%d %H:%M:%S")
write_to_log "Start Time: $start_time" "$time_file"
write_to_log "Command: $command" "$time_file"

# Execute the command in the background
"$@" &
command_pid=$!

# Start the logging loop
while true; do
    # Check if the command is still running
    if [ ! -e "/proc/$command_pid" ]; then
        break
    fi

    # Log NVIDIA GPU utilization using dmon
    gpu_output=$(nvidia-smi dmon -s u -c 1)
    write_to_log "$gpu_output" "$gpu_log_file"

    # Log CPU statistics using mpstat -P ALL
    cpu_output=$(mpstat -P ALL 1 1)
    write_to_log "$cpu_output" "$cpu_log_file"

    # Log sensor information using sensors
    sensors_output=$(sensors)
    write_to_log "$sensors_output" "$sensors_log_file"

    # Sleep for the specified interval before the next iteration
    sleep "$interval"
done

# Wait for the command to finish and capture the exit status
wait $command_pid
exit_status=$?

# Capture end time
end_time=$(date +"%Y-%m-%d %H:%M:%S")

# Write the captured information to the log files
write_to_log "End Time: $end_time" "$time_file"
write_to_log "Exit Status: $exit_status" "$time_file"