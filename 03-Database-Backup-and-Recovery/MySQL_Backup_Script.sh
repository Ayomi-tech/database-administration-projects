#!/bin/bash
# MySQL Script for Daily Full Database Backup
# Database: candystore
# Frequency: Daily (Target RPO: 15 minutes, foundation for recovery)


# --- Configuration ---
DB_NAME="candystore" 
RETENTION_DAYS=7  #Keep backups for 7 days
BACKUP_PATH="$HOME/scripts/db_admin/backups"
DATE_STAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_PATH}/${DB_NAME}_FULL_${DATE_STAMP}.sql"
COMPRESSED_FILE="${BACKUP_FILE}.gz"
LOG_FILE="${BACKUP_PATH}/backup_log.txt"
MYSQLDUMP_PATH="/usr/local/opt/mysql-client/bin/mysqldump"

# --- Script Logic ---

#1. Check and Create Backup Directory
if ! mkdir -p "$BACKUP_PATH"; then
    echo "FATAL ERROR: Could not create backup path: $BACKUP_PATH" >> "$LOG_FILE"
    exit 1

fi

echo "---Starting Full Backup for $DB_NAME as $(date)---" >> "$LOG_FILE"

#2. Execute the logical backup using mysqldump
if "$MYSQLDUMP_PATH" --defaults-extra-file=$HOME/.mysql.cnf --single-transaction --routines --triggers "$DB_NAME" > "$BACKUP_FILE" 2>> "$LOG_FILE"
    then 
        echo "Dump Created Successfully: $BACKUP_FILE" >> "$LOG_FILE"

        # Compress the file to save to disk
        gzip "$BACKUP_FILE"

        #Log the compressed name
        echo "Backup Compressed to $COMPRESSED_FILE" >> "$LOG_FILE"

        #3. Retention Policy: Delete files older than $RETENTION_DAYS days
        echo "Running cleanup (deleting backups older than $RETENTION_DAYS days)..." >> "$LOG_FILE"
        find "$BACKUP_PATH" -type f -name "${DB_NAME}_FULL_*.sql.gz" -mtime +"$RETENTION_DAYS" -delete
        echo "Cleanup Complete." >> "$LOG_FILE"

        echo "---Full Backup Complete at $(date)---" >> "$LOG_FILE"

else 
    # '2>> "$LOG_FILE"' above captures the mysqldump error message
    echo "ERROR: mysqldump failed for $DB_NAME. Check log file for details." >> $LOG_FILE

    #Remove the failed (empty) file.
    rm -f "$BACKUP_FILE"

fi
