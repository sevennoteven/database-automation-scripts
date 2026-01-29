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
$startTime = Get-Date
$totalTests = 0
$passedTests = 0
$failedTests = 0

Write-Host "===MySQL Database Health Check===" -ForegroundColor Green
Write-Host ""
Write-Host "Server: $server" -ForegroundColor Cyan
Write-Host "Database: $database" -ForegroundColor Cyan
Write-Host "Started: $($startTime.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Cyan
Write-Host ""

$tempConfig = @"
[client]
user=$user
password=$password
host=$server
database=$database
"@

$tempConfigPath = "$env:TEMP\my_temp.cnf"
$tempConfig | Out-File -FilePath $tempConfigPath -Encoding ascii

Write-Host "TEST 1: Connection Test" -ForegroundColor Yellow

$result = mysql --defaults-file=$tempConfigPath -e "SELECT 1 AS test;" 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "[PASS] Successfully connected" -ForegroundColor Green
    $passedTests++
} else {
    Write-Host "[FAIL] Could not connect" -ForegroundColor Red
    Write-Host "Error: $result" -ForegroundColor Red
    $failedTests++
    exit
}

$totalTests++

Write-Host ""
Write-Host "TEST 2: Database Size Check" -ForegroundColor Yellow

$sizeQuery = "SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb FROM information_schema.tables WHERE table_schema = '$database';"
$sizeResult = mysql --defaults-file=$tempConfigPath -e $sizeQuery -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $sizeMB = $sizeResult.Trim()
    Write-Host "  Database: $database" -ForegroundColor White
    Write-Host "  Size: $sizeMB MB" -ForegroundColor White
    Write-Host "[PASS] Database size retrieved" -ForegroundColor Green
    $passedTests++
} else {
    Write-Host "[FAIL] Could not get database size" -ForegroundColor Red
    Write-Host "Error: $result" -ForegroundColor Red
    $failedTests++
}

$totalTests++


Write-Host ""
Write-Host "TEST 3: Table Count" -ForegroundColor Yellow

$countTable = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$database';"
$countResult = mysql --defaults-file=$tempConfigPath -e $countTable -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $tableCount = $countResult.Trim()
    Write-Host "  Tables: $tableCount" -ForegroundColor White
    Write-Host "[PASS] Table count retrieved" -ForegroundColor Green
    $passedTests++
} else {
    Write-Host "[FAIL] Could not get table count" -ForegroundColor Red
    Write-Host "Error: $result" -ForegroundColor Red
    $failedTests++
}

$totalTests++

Write-Host ""
Write-Host "TEST 4: MySQL Version" -ForegroundColor Yellow

$versionCheck = "SELECT VERSION();"
$versionCheckResult = mysql --defaults-file=$tempConfigPath -e $versionCheck -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $version = $versionCheckResult.Trim()
    Write-Host "  Version: $version" -ForegroundColor White
    Write-Host "[PASS] Version retrieved" -ForegroundColor Green
    $passedTests++
} else {
    Write-Host "[FAIL] Could not retrieve data" -ForegroundColor Red
    Write-Host "Error: $result" -ForegroundColor Red
    $failedTests++
}

$totalTests++

Write-Host ""
Write-Host "TEST 5: Sample Data Check" -ForegroundColor Yellow

$employeeTableCount = "SELECT COUNT(*) FROM employees;"
$tableCountResult = mysql --defaults-file=$tempConfigPath -e $employeeTableCount -N -s 2>&1

if ($LASTEXITCODE -eq 0) {
    $tcountResult = $tableCountResult.Trim()
    Write-Host "  Employee records: $tcountResult" -ForegroundColor White
    Write-Host "[PASS] Data retrieved" -ForegroundColor Green
    $passedTests++
} else {
    Write-Host "[FAIL] Could not retrieve data" -ForegroundColor Red
    Write-Host "Error: $result" -ForegroundColor Red
    $failedTests++
}

$totalTests++

Write-Host ""
Remove-Item $tempConfigPath -Force
$endTime = Get-Date
$elapsed = $endTime - $startTime

Write-Host "==== SUMMARY ====" -ForegroundColor Cyan
Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $failedTests" -ForegroundColor Red
$passrate = ($passedTests / $totalTests) * 100
Write-Host "Pass Rate: $passrate%" -ForegroundColor White
Write-Host ""
Write-Host "Finished: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Cyan
Write-Host "Duration: $($elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
Write-Host "=== Health Check Complete ===" -ForegroundColor Green