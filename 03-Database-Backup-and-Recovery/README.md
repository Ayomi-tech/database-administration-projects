# 03 — Database Backup & Recovery: Candystore Database

## 🛡️ Project Overview
This project implements a **secure, automated, and validated backup & recovery workflow** for the production-critical `candystore` MySQL database.  
It demonstrates core DBA responsibilities including data protection, operational discipline, and disaster recovery readiness.

Core goals accomplished:
- Automated **daily full backups**  
- Secure handling of database credentials  
- Rotating retention with automatic cleanup  
- Full integrity-tested database recovery 

---

## 🎯 Strategic Objectives

| Objective                                    | Rationale & Outcome                                                                                                                                                               |
| ---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Establish Reliable Daily Backup**          | Ensures a guaranteed recovery baseline (the full backup) is available daily, minimizing the potential scope of data loss.                                                         |
| **Ensure Security & Operational Discipline** | Credentials are never exposed in the shell script. Authentication relies solely on the **secure MySQL option file (`~/.my.cnf`)** with required `chmod 600` permissions.          |
| **Validate Disaster Recovery (DR)**          | A backup is only successful if it can be restored. This project includes a **full recovery test** into a dedicated `candystore_recovery_test` database to prove backup integrity. |


* Automated **daily full backups** using a Bash script scheduled via `cron`.
* Secure handling of database credentials using the MySQL option file (`~/.my.cnf`).
* Rotating retention policy with automatic cleanup (`find -mtime`).
* Full integrity-tested database recovery and validation.

---

## ⚙️ Backup Strategy & Configuration

| Setting                                   | Value                       | Rationale                                                                                                                                              |
|-------------------------------------------|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Target Database**                       | `candystore`                | The critical application database.                                                                                                                     |
| **Backup Frequency**                      | Daily                       | Forms the baseline protection for all recovery scenarios.                                                                                              |
| **Target RPO (Recovery Point Objective)** | 15 minutes                  | **Professional Note:** The daily full backup is the foundation; achieving a 15-minute RPO requires layering continuous incremental (binary log) backups, which is the next planned step in the DR plan. |
| **Retention Policy**                      | 7 days (`RETENTION_DAYS=7`) | Automatically prunes old backups using the `find -mtime` command to manage disk usage efficiently.                                                     |
| **Security Model**                        | `~/.my.cnf`                 | Prevents credential exposure and enforces strict access control.                                                                                       |
| **Compression**                           | Enabled (`gzip`)            | Saves storage and speeds up transfer and archiving.                                                                                                    |


---
## 🚀 Technical Highlights & Script Features
The core script (`MySQL_Backup_Script.sh`) is designed for maximum reliability in a production environment.

* **Reliability:** Uses the **full path** to the utility (`/usr/local/opt/mysql-client/bin/mysqldump`) to eliminate dependency on environment variables and common `$PATH` conflicts.
* **Security Focus:** Explicitly forces the use of the protected credentials file via the flag: `--defaults-extra-file=$HOME/.my.cnf`.
* **Portability:** Uses the `$HOME` variable for defining file paths, making the script instantly portable to any user account or standardized home directory.


## 📂 Project Folder Structure
03-Database-Backup-and-Recovery/
│
├── MySQL_Backup_Script.sh        # Main backup automation script
├── README.md                     # Documentation
│
└── backups/                      # (Optional) Backup output folder
    ├── candystore_FULL_*.sql.gz  # Compressed full backups
    └── backup_log.txt/           # Backup logs


## 💾 Recovery Validation (Proof of Integrity)
This procedure validates the entire backup workflow. The commands must be executed from the Bash shell.

### **Procedure Summary**
| Step                          | Command                                                             | Description                                                                                          |
|-------------------------------|---------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **1. Create Recovery Target** | `mysql -e "CREATE DATABASE candystore_recovery_test;"`              | Isolates the recovery test from the production database.                                             |
| **2. Decompress Backup**      | `gunzip candystore_FULL_*.sql.gz`                                   | Decompresses the file in the backups directory, preparing it for import.                             |
| **3. Perform Restore**        | `mysql -u root -p candystore_recovery_test < candystore_FULL_*.sql` | Executes the bulk import using the **Bash redirection operator** (`<`) into the clean test database. |
| **4. Validate Data**          | `mysql -e "USE candystore_recovery_test; SHOW TABLES;"`             | Confirms the schema and tables were imported successfully.                                           |
| **5. Cleanup**                | `rm candystore_FULL_*.sql`                                          | Deletes the large, uncompressed file to save disk space.                                             |


### **Successful Run Log (`backup_log.txt`)**
The log in backup_log.txt confirms the successful creation, compression, and retention of the latest backup.



















