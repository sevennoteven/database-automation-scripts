# MySQL Database Health Check Script

## Purpose
Automates daily health checks for MySQL databases. Runs multiple validation tests and provides formatted output without requiring manual server access or database inspection.

## Features
- Connection testing
- Database size monitoring
- Table count
- MySQL version check
- Sample data validation

## Requirements
- PowerShell 5.1 or higher
- MySQL Server 5.7 or higher
- MySQL command-line client installed

## Setup
1. Clone or download this repository
2. Open `Database-HealthCheck.ps1` in a text editor
3. Update the connection parameters (lines 10-12):
   - `$database` - Your database name
   - `$user` - Your MySQL username  
   - `$password` - Your MySQL password
4. Save the file

## Usage
```powershell
.\scripts\Database-HealthCheck.ps1
```

## Example Output
```
===MySQL Database Health Check===

Server: localhost
Database: dba_practioce

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

=== Health Check Complete ===
```

## Notes
- This script creates a temporary config file (`my_temp.cnf`) in your Windows temp folder and deletes it after execution
- The script assumes the MySQL command-line client is in your system PATH
- If you get "mysql: command not found", add MySQL bin folder to your PATH or run from MySQL bin directory
- For security, never commit real passwords to version control - use environment variables or prompt for password in production