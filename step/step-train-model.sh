#!/bin/bash

# Check if a configuration file is provided as an argument
if [ $# -lt 2 ]; then
    echo "Usage: $0 <num_timesteps> <config_file>"
    exit 1
fi

base_num_timesteps=$1
config_file=$2

# Source the configuration file
if [ ! -f "$config_file" ]; then
    echo "Configuration file not found: $config_file"
    exit 1
fi
source "$config_file"

# Set the file extension for the model files
extension=".zip"

# Function to select a random state
select_random_state() {
    local random_index=$((RANDOM % ${#states[@]}))
    echo "${states[$random_index]}"
}

# Initialize total timesteps and model_to_load
total_timesteps=0
model_to_load="${model_dir}${base_model}${extension}"

# Main loop
while true; do
    # Update total timesteps
    total_timesteps=$((total_timesteps + base_num_timesteps))

    # Check if random_state is true and select a random state
    if [[ "$random_state" == "true" ]]; then
        selected_state=$(select_random_state)
    else
        selected_state=$state
    fi

    # Prepare the log file name
    log_file_name="${base_model}+${total_timesteps}+${selected_state//.state/}.log"
    log_file="${model_dir}${log_file_name}"

    echo "Running model training with state: $selected_state" | tee -a "$log_file"
    output=$(python3 model_trainer.py --env=$env --state=$selected_state --num_timesteps=$base_num_timesteps --num_env=64 --output_basedir=$output_basedir --load_p1_model=$model_to_load 2>&1 | tee -a "$log_file")

    # Extract the 'Model saved to' path from the output
    model_saved_to=$(echo "$output" | grep -oP 'Model saved to:\K.*')
    if [[ ! "$model_saved_to" =~ \.zip$ ]]; then
        model_saved_to="${model_saved_to}.zip"
    fi

    if [ -z "$model_saved_to" ]; then
        echo "Model training did not complete successfully or model path not found in output." | tee -a "$log_file"
        exit 1
    fi

    echo "Model saved at: $model_saved_to" | tee -a "$log_file"

    # Prepare the new model name with total timesteps
    new_model_name="${base_model}+${total_timesteps}+${selected_state//.state/}${extension}"
    cp "$model_saved_to" "${model_dir}${new_model_name}"

    echo "Copied and renamed model file for next iteration: $new_model_name" | tee -a "$log_file"

    # Update model_to_load for the next iteration
    model_to_load="${model_dir}${new_model_name}"
done
