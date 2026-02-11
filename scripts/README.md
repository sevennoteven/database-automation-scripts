# MySQL Database & Server Health Check Script

## Purpose
Automates daily health checks for MySQL databases and Windows server performance. Runs multiple validation tests and provides formatted output without requiring manual server access or database inspection.

## Features
```
**Database Checks:**
- Connection testing with automatic exit on failure
- Database size monitoring
- Table count validation
- MySQL version check
- Sample data validation
- Long running query detection (> 5 minutes)
- Blocking session monitoring
- Stale connection detection (> 6 hours)
- Backup status monitoring (validates backups within 24 hours)

**Server Performance Checks:**
- CPU usage monitoring
- Memory utilization tracking
- Disk space monitoring (C: drive)

**Reporting:**
- Execution timestamps and duration tracking
- Test summary with pass/fail statistics and pass rate percentage
- Detailed error messages for troubleshooting
```

## Requirements
```
- PowerShell 5.1 or higher
- MySQL Server 5.7 or higher
- MySQL command-line client installed
```

## Setup
```
1. Clone or download this repository
2. Open `Database-HealthCheck.ps1` in a text editor
3. Update the connection parameters (lines 10-12):
   - `$database` - Your database name
   - `$user` - Your MySQL username  
   - `$password` - Your MySQL password
4. Save the file
```

## Usage
```
powershell
.\scripts\Database-HealthCheck.ps1
```

## Example Output
```
===MySQL Database & Server Health Check===

Server: localhost
Database: dba_practioce
Started: 2026-02-02 10:01:51

TEST 1: Connection Test
[PASS] Successfully connected

TEST 2: Database Size Check
  Database: dba_practioce
  Size: 0.02 MB
[PASS] Database size retrieved

TEST 3: Table Count
  Tables: 1
[PASS] Table count retrieved

TEST 4: MySQL Version
  Version: 5.7.44-log
[PASS] Version retrieved

TEST 5: Sample Data Check
  Employee records: 5
[PASS] Data retrieved

TEST 6: CPU Usage
  CPU: 2.65%
[PASS] CPU usage retrieved

TEST 7: Memory Usage
  Memory: 26.17%
[PASS] Memory usage retrieved

TEST 8: Disk Usage
  Disk: 37.85%
[PASS] Disk usage retrieved

TEST 9: Long Running Queries Check
  Long Running Queries: 0
[PASS] No long running queries detected

TEST 10: Blocking Session Check
  Blocking Session: 0
[PASS] No Blocking Session detected

TEST 11: Connection Over 6 Hrs Check
  Connection Over 6 Hours: 0
[PASS] No Connection Over 6 Hours detected

==== SUMMARY ====
Total Tests: 11
Passed: 11
Failed: 0
Pass Rate: 100%

Finished: 2026-02-02 10:01:53
Duration: 1.4404189 seconds
=== Health Check Complete ===
```

## Notes
- This script creates a temporary config file (`my_temp.cnf`) in your Windows temp folder and deletes it after execution
- The script assumes the MySQL command-line client is in your system PATH
- If you get "mysql: command not found", add MySQL bin folder to your PATH or run from MySQL bin directory
- For security, never commit real passwords to version control - use environment variables or prompt for password in production

## Error Handling
- If the connection test (TEST 1) fails, the script will display the MySQL error message and exit immediately
- For other tests, failures will display error details but the script will continue running
- All errors are displayed in red for easy identification

## Thresholds & Warnings
Currently all checks are informational. Future versions may include:
- Warning when disk space exceeds 80%
- Alert when CPU sustained above 90%
- Memory usage notifications