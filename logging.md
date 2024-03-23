# User Manual: System Monitoring and Logging Script

Note: I used Claude 3 to help writing this.
1. Introduction
   The System Monitoring and Logging Script is a bash script that allows you to monitor and log various system metrics while running a specified command or task. It captures GPU utilization, CPU statistics, and sensor information at regular intervals and saves the data to separate log files.

2. Prerequisites
   - Linux operating system (e.g., Ubuntu)
   - Bash shell
   - `nvidia-smi` command (for NVIDIA GPU monitoring)
   - `mpstat` command (for CPU statistics monitoring)
   - `sensors` command (for sensor information monitoring)

3. Script Usage
   The script can be run from the command line using the following syntax:
   ```bash
   sh log.sh [-v] [-n interval] [-r run_name] [command]
   ```

   Options:
   - `-v`: Enable verbose mode to print the logged information to the console.
   - `-n interval`: Set the logging interval in seconds (default: 5 seconds).
   - `-r run_name`: Specify a custom run name for the log files (default: "program_run").
   - `command`: The command or task to execute and monitor.

   Example usage:
   ```bash
   sh log.sh -v -n 10 -r custom_run python my_script.py
   ```

4. Log Files
   The script generates separate log files for each monitored component:
   - `<run_name>_gpu_utilization.txt`: Contains GPU utilization information captured using `nvidia-smi dmon`.
   - `<run_name>_cpu_stats.txt`: Contains CPU statistics captured using `mpstat -P ALL`.
   - `<run_name>_sensors.txt`: Contains sensor information captured using the `sensors` command.

   The log files are created in the same directory as the script and are named based on the specified or default run name.

5. Monitoring Process
   When the script is executed, it performs the following steps:
   - Parses the command-line options to set the logging interval, run name, and verbose mode.
   - Generates the log file names based on the run name.
   - Captures the start time and saves it to the GPU utilization log file.
   - Executes the specified command or task in the background.
   - Starts the monitoring loop, which runs until the command finishes:
     - Checks if the command is still running.
     - Captures GPU utilization using `nvidia-smi dmon` and saves it to the GPU utilization log file.
     - Captures CPU statistics using `mpstat -P ALL` and saves it to the CPU stats log file.
     - Captures sensor information using the `sensors` command and saves it to the sensors log file.
     - Sleeps for the specified logging interval before the next iteration.
   - Waits for the command to finish and captures the exit status.
   - Captures the end time and saves it to the GPU utilization log file along with the exit status.

6. Troubleshooting
   - If the script is not capturing the expected information, ensure that the required commands (`nvidia-smi`, `mpstat`, `sensors`) are installed and accessible.
   - If the log files are not being created or updated, check the permissions of the script and the directory where the log files are being saved.
   - If the custom run name is not being applied, make sure to provide the `-r` option before the run name argument.

7. Conclusion
   The System Monitoring and Logging Script provides a convenient way to monitor and log system metrics while running a specific command or task. By capturing GPU utilization, CPU statistics, and sensor information at regular intervals, it allows for performance analysis and troubleshooting. The generated log files can be used for further examination and post-processing.





# Developer's Manual: System Monitoring and Logging Script

1. Overview
   The System Monitoring and Logging Script is a bash script that enables monitoring and logging of system metrics while executing a specified command or task. It captures GPU utilization, CPU statistics, and sensor information at configurable intervals and saves the data to separate log files. The script is designed to be easily extensible and customizable for developers.

2. Script Structure
   The script consists of the following main sections:
   - Variable declarations: Initializes variables for the logging interval, run name, and verbose mode.
   - Function definitions: Defines the `write_to_log` function for writing data to log files.
   - Command-line option parsing: Uses `getopts` to parse command-line options and set the corresponding variables.
   - Log file generation: Generates log file names based on the run name.
   - Start time capture: Captures the start time and saves it to the GPU utilization log file.
   - Command execution: Executes the specified command or task in the background.
   - Monitoring loop: Continuously captures system metrics until the command finishes.
   - End time capture: Captures the end time and saves it to the GPU utilization log file along with the exit status.

3. Customization and Extension
   Developers can customize and extend the script to suit their specific requirements:
   - Logging interval: Modify the default logging interval by changing the value of the `interval` variable.
   - Log file names: Adjust the log file names and paths by modifying the `gpu_log_file`, `cpu_log_file`, and `sensors_log_file` variables.
   - Additional metrics: Add more monitoring commands or metrics by inserting the appropriate commands within the monitoring loop and saving the output to respective log files.
   - Logging format: Customize the format of the logged data by modifying the `write_to_log` function or the variables passed to it.
   - Command-line options: Extend the command-line options by adding new cases to the `getopts` loop and handling the corresponding variables.

4. Function Reference
   - `write_to_log` function:
     - Description: Writes the provided data to the specified log file and optionally prints it to the console if verbose mode is enabled.
     - Parameters:
       - `$1`: The data to be logged.
       - `$2`: The log file path.
     - Usage: `write_to_log "data" "log_file.txt"`

5. Monitoring Commands
   The script uses the following commands for monitoring system metrics:
   - `nvidia-smi dmon`: Captures GPU utilization information for NVIDIA GPUs.
   - `mpstat -P ALL`: Captures CPU statistics for all CPUs.
   - `sensors`: Captures sensor information, including temperatures and fan speeds.

   Developers can modify or replace these commands based on their specific monitoring requirements.

6. Error Handling and Logging
   The script includes basic error handling and logging:
   - Invalid command-line options: If an invalid option is provided, an error message is printed to stderr, and the script exits with a status code of 1.
   - Command execution: The script captures the exit status of the executed command and saves it to the GPU utilization log file.

   Developers can enhance the error handling and logging mechanisms by adding more robust checks, error messages, and logging statements throughout the script.

7. Testing and Debugging
   When making modifications to the script, developers should thoroughly test and debug their changes:
   - Test with different command-line options and arguments to ensure proper handling.
   - Verify that the log files are created and contain the expected data.
   - Check the console output if verbose mode is enabled to ensure the desired information is printed.
   - Use debugging techniques such as adding echo statements or using the `set -x` command to enable script debugging and trace the execution flow.

8. Conclusion
   The System Monitoring and Logging Script provides a foundation for monitoring and logging system metrics during the execution of a command or task. Developers can customize and extend the script to include additional metrics, modify the logging format, and integrate it into their existing workflows. By leveraging the script's functionality, developers can gain insights into system performance and troubleshoot issues more effectively.

Remember to refer to the script's code and comments for detailed implementation details and guidance on customization and extension possibilities.
