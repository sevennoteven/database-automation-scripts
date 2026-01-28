# Database Health Check Script for MySQL
# Author: Jay
# Date: January 28, 2026
#
# SETUP: Replace the connection parameters below with your actual MySQL credentials
# DO NOT commit real passwords to version control!

# Connection parameters - UPDATE THESE WITH YOUR CREDENTIALS
$server = "localhost"
$database = "your_database_name" #change to your database name
$user = "your_mysql_username" #change to your username
$password  = "your_mysql_password" #change to your password

Write-Host "===MySQL Database Health Check===" -ForegroundColor Green
Write-Host "Server: $server" -ForegroundColor Cyan
Write-Host "Database: $database" -ForegroundColor Cyan
Write-Host ""

$tempConfig = @"
[client]
user=$user
password=$password
host=$server
"@

$tempConfigPath = "$env:TEMP\my_temp.cnf"
$tempConfig | Out-File -FilePath $tempConfigPath -Encoding ascii

Write-Host "TEST 1: Connection Test" -ForegroundColor Yellow

$result = mysql --defaults-file=$tempConfigPath -e "SELECT 1 AS test;" 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "[PASS] Successfully connected" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Could not connect" -ForegroundColor Red
}

Write-Host ""
Write-Host "TEST 2: Database Size Check" -ForegroundColor Yellow

$sizeQuery = "SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb FROM information_schema.tables WHERE table_schema = '$database';"
$sizeResult = mysql --defaults-file=$tempConfigPath -e $sizeQuery -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $sizeMB = $sizeResult.Trim()
    Write-Host "  Database: $database" -ForegroundColor White
    Write-Host "  Size: $sizeMB MB" -ForegroundColor White
    Write-Host "[PASS] Database size retrieved" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Could not get database size" -ForegroundColor Red
}


Write-Host ""
Write-Host "TEST 3: Table Count" -ForegroundColor Yellow

$countTable = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$database';"
$countResult = mysql --defaults-file=$tempConfigPath -e $countTable -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $tableCount = $countResult.Trim()
    Write-Host "  Count: $tableCount" -ForegroundColor White
    Write-Host "[PASS] Table count retrieved" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Could not get table count" -ForegroundColor Red
}

Write-Host ""
Write-Host "TEST 4: MySQL Version" -ForegroundColor Yellow

$versionCheck = "SELECT VERSION();"
$versionCheckResult = mysql --defaults-file=$tempConfigPath -e $versionCheck -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $version = $versionCheckResult.Trim()
    Write-Host "  Version: $version" -ForegroundColor White
    Write-Host "[PASS] Version retrieved" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Could not get database version" -ForegroundColor Red
}

Write-Host ""
Remove-Item $tempConfigPath -Force
Write-Host "=== Health Check Complete ===" -ForegroundColor Green