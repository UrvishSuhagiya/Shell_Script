#!/bin/bash

# Arguments For Source & Backup
source_dir=$1
backup_dir=$2
timestamp=$(date '+%d-%m-%y_%H-%M-%S')

# if source_dir & backup_dir are valid then
if [ ! -d "$source_dir" ]; then
  echo "Source directory does not exist: $source_dir"
  exit 1
fi

if [ ! -d "$backup_dir" ]; then
  echo "Backup directory does not exist: $backup_dir"
  exit 1
fi

# Fun For create backup
function create_backup {
  # it will compress source dir to zip
  zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null
  if [ $? -eq 0 ]; then
    echo "Backup created successfully at ${backup_dir}/backup_${timestamp}.zip"
    #backup dir name is = backup_backupTIME.zip ex. backup_14-10-24_4-34-22
  else
    echo "Backup failed for $timestamp"
    exit 1
  fi
}

# Fun for perform rotation (keep only the 3 most recent backups)
function perform_rotation {
  # Ensure we list backups from the correct directory
  backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))
  if [ "${#backups[@]}" -gt 3 ]; then
    backups_to_remove=("${backups[@]:3}")
    for backup in "${backups_to_remove[@]}"; do
      rm "$backup" # remove Backups
      if [ $? -eq 0 ]; then
        echo "Removed old backup: $backup"
      else
        echo "Failed to remove backup: $backup"
      fi
    done
  fi
}

# Call Functions
create_backup
perform_rotation
