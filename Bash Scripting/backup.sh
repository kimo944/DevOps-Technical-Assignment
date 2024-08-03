#!/bin/bash

# Set variables
TIMESTAMP=$(date +"%F_%H-%M-%S")
BACKUP_DIR="C:\Users\karee\OneDrive\Desktop"
MYSQL_USER="kimo"
MYSQL_PASSWORD="kimo1234"
MYSQL_DATABASE="DATA"
LOG_FILE="$BACKUP_DIR/backup.log"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Export database dump
DUMP_FILE="$BACKUP_DIR/$MYSQL_DATABASE-$TIMESTAMP.sql"
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "$DUMP_FILE"

# Check if the dump was successful
if [ $? -eq 0 ]; then
  echo "$TIMESTAMP: Backup successful. File saved as $DUMP_FILE" >> "$LOG_FILE"
else
  echo "$TIMESTAMP: Backup failed." >> "$LOG_FILE"
fi
