#!/bin/bash

DATA_DIR=./data
BACKUP_DIR=./backups

check_for_package () {
  if dpkg-query -s "$1" 1>/dev/null 2>&1; then
    return 0
  else
    if apt-cache show "$1" 1>/dev/null 2>&1; then
      return 1
    else
      return 2
    fi
  fi
}

backup () {
  DATE=`date +%Y-%m-%d:%H:%M:%S`
  7za a "$BACKUP_DIR/$DATE.7z" "$DATA_DIR/"
}

echo "INFO > Backup initializing..."

check_for_package p7zip-full
RES=$?

if [ "$RES" == 0 ]; then
  echo "INFO > Backuping contents of $DATA_DIR to $BACKUP_DIR"
  backup
elif [ "$RES" == 1 ]; then
  echo "INFO > p7zip package not found. Attempting to install p7zip-full from apt-get..."
  sudo apt-get install p7zip-full
  backup
else
  echo "ERROR > p7zip package not found, and could not be installed automatically. Exiting..."
fi
