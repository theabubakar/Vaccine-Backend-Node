@echo off
setlocal enabledelayedexpansion

REM Vaccine Management System Setup Script for Windows
REM This script sets up the entire project with Docker

echo 🏥 Vaccine Management System Setup
echo ==================================

REM Check if Docker is installed
echo [INFO] Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

echo [SUCCESS] Docker and Docker Compose are installed

REM Check if Docker is running
echo [INFO] Checking if Docker is running...
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)
echo [SUCCESS] Docker is running

REM Create environment file if it doesn't exist
if not exist .env (
    echo [INFO] Creating .env file...
    (
        echo NODE_ENV=production
        echo PORT=3000
        echo MONGODB_URI=mongodb://admin:password123@mongodb:27017/vaccine_management?authSource=admin
    ) > .env
    echo [SUCCESS] .env file created
) else (
    echo [WARNING] .env file already exists, skipping creation
)

REM Build and start services
echo [INFO] Building and starting services...
docker-compose down >nul 2>&1
docker-compose up -d --build

if errorlevel 1 (
    echo [ERROR] Failed to start services
    pause
    exit /b 1
)

echo [SUCCESS] Services started successfully

REM Wait for services to be ready
echo [INFO] Waiting for services to be ready...

REM Wait for Backend API
echo [INFO] Waiting for Backend API...
set timeout=60
:wait_backend
curl -s http://localhost:3000/api >nul 2>&1
if not errorlevel 1 goto backend_ready
timeout /t 2 /nobreak >nul
set /a timeout-=2
if %timeout% leq 0 (
    echo [ERROR] Backend API failed to start within 60 seconds
    pause
    exit /b 1
)
goto wait_backend
:backend_ready
echo [SUCCESS] Backend API is ready

REM Wait for Frontend
echo [INFO] Waiting for Frontend...
set timeout=60
:wait_frontend
curl -s http://localhost:8080 >nul 2>&1
if not errorlevel 1 goto frontend_ready
timeout /t 2 /nobreak >nul
set /a timeout-=2
if %timeout% leq 0 (
    echo [ERROR] Frontend failed to start within 60 seconds
    pause
    exit /b 1
)
goto wait_frontend
:frontend_ready
echo [SUCCESS] Frontend is ready

REM Display service information
echo.
echo 🎉 Setup Complete!
echo ==================
echo.
echo 📱 Frontend (Flutter Web): http://localhost:8080
echo 🔧 Backend API: http://localhost:3000
echo 📚 API Documentation: http://localhost:3000/api-docs
echo 🗄️  MongoDB: localhost:27017
echo.
echo 🔑 Default MongoDB Credentials:
echo    Username: admin
echo    Password: password123
echo    Database: vaccine_management
echo.
echo 📋 Useful Commands:
echo    View logs: docker-compose logs -f
echo    Stop services: docker-compose down
echo    Restart services: docker-compose restart
echo    View service status: docker-compose ps
echo.

echo [SUCCESS] Vaccine Management System is ready to use!
echo.
echo Press any key to continue...
pause >nul
