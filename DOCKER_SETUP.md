# 🐳 Complete Docker Setup Guide

This guide will help you run the entire healthcare management system using Docker with all four applications and seed data.

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed and running
- Git (to clone the repository)

### One-Command Setup
```bash
# Clone and start everything
git clone <your-repo-url>
cd Vaccine-Flutter-Node
docker-compose up -d --build
```

That's it! All services will be available at:
- **Backend API**: http://localhost:3000
- **Admin System**: http://localhost:8081
- **Doctor Portal**: http://localhost:8082
- **Patient Panel**: http://localhost:8083

## 📋 What Gets Started

### Services Overview
| Service | Port | Description |
|---------|------|-------------|
| **MongoDB** | 27017 | Database with seed data |
| **Backend API** | 3000 | Node.js REST API |
| **Admin System** | 8081 | Vaccine/Brand/Doctor Management |
| **Doctor Portal** | 8082 | Doctor Clinic Management |
| **Patient Panel** | 8083 | Patient Welcome Page |

### 🗄️ Database Features
- **Automatic Seeding**: Pre-populated with test data
- **Persistent Storage**: Data survives container restarts
- **Test Credentials**: Ready-to-use doctor accounts

## 🔑 Test Credentials

### Doctor Login Credentials
| Email | Password | Role |
|-------|----------|------|
| john.smith@hospital.com | Doc123!@# | General Practitioner |
| sarah.johnson@clinic.com | Doc456!@# | Pediatrician |
| michael.brown@medical.com | Doc789!@# | Cardiologist |

### Sample Data Included
- **5 Brands**: Pfizer, Moderna, Johnson & Johnson, etc.
- **4 Vaccines**: COVID-19, Flu, Hepatitis B, MMR
- **4 Doses**: Various vaccination schedules
- **3 Doctors**: Different specialties
- **4 Clinics**: Multiple clinics per doctor

## 🛠️ Docker Commands

### Start All Services
```bash
docker-compose up -d --build
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f admin-system
docker-compose logs -f doctor-portal
docker-compose logs -f patient-panel
```

### Stop All Services
```bash
docker-compose down
```

### Stop and Remove Data
```bash
docker-compose down -v
```

### Restart Specific Service
```bash
docker-compose restart backend
```

### Rebuild Specific Service
```bash
docker-compose up -d --build backend
```

## 🔧 Development Commands

### Access MongoDB
```bash
# Connect to MongoDB container
docker exec -it vaccine-mongodb mongosh -u admin -p password123

# Use the database
use vaccine_management

# View collections
show collections

# View sample data
db.doctors.find().pretty()
db.clinics.find().pretty()
```

### View Container Status
```bash
docker-compose ps
```

### Check Service Health
```bash
# Backend health check
curl http://localhost:3000/api/health

# All services status
docker-compose ps
```

## 🐛 Troubleshooting

### Port Conflicts
If you get port conflicts, check what's running:
```bash
# Windows
netstat -ano | findstr :3000
netstat -ano | findstr :8081

# Linux/Mac
lsof -i :3000
lsof -i :8081
```

### Container Issues
```bash
# Remove all containers and start fresh
docker-compose down -v
docker system prune -f
docker-compose up -d --build
```

### Database Issues
```bash
# Reset database with fresh seed data
docker-compose down -v
docker-compose up -d --build
```

### Build Issues
```bash
# Clean build cache
docker-compose build --no-cache
docker-compose up -d
```

## 📁 Project Structure

```
Vaccine-Flutter-Node/
├── docker-compose.yml          # Main Docker configuration
├── seed-data.js               # Database seed data
├── mongo-init.js              # MongoDB initialization
├── Dockerfile                 # Backend Dockerfile
├── vaccine_app/               # Admin System
│   ├── Dockerfile
│   └── nginx.conf
├── doctor_portal_app/         # Doctor Portal
│   ├── Dockerfile
│   └── nginx.conf
├── patient_panel/             # Patient Panel
│   ├── Dockerfile
│   └── nginx.conf
└── models/                    # Backend models
    ├── Vaccine.js
    ├── Doctor.js
    ├── Clinic.js
    └── ...
```

## 🌐 API Endpoints

### Backend API (http://localhost:3000)
- **Health Check**: `/api/health`
- **Vaccines**: `/api/vaccines`
- **Doses**: `/api/doses`
- **Brands**: `/api/brands`
- **Doctors**: `/api/doctors`
- **Clinics**: `/api/clinics`
- **Auth**: `/api/auth`
- **API Docs**: `/api-docs`

## 🎯 Testing the System

### 1. Admin System (http://localhost:8081)
- Manage vaccines, doses, brands
- Create and manage doctors
- View system statistics

### 2. Doctor Portal (http://localhost:8082)
- Login with test credentials
- Create and manage clinics
- View clinic dashboard

### 3. Patient Panel (http://localhost:8083)
- Welcome page
- Future patient features

### 4. Backend API (http://localhost:3000)
- REST API for all operations
- Swagger documentation at `/api-docs`

## 🔄 Updates and Maintenance

### Update All Services
```bash
git pull origin main
docker-compose down
docker-compose up -d --build
```

### Update Specific Service
```bash
# Update only backend
docker-compose up -d --build backend

# Update only frontend
docker-compose up -d --build admin-system
```

## 📊 Monitoring

### Resource Usage
```bash
docker stats
```

### Container Health
```bash
docker-compose ps
```

### Log Monitoring
```bash
# Follow all logs
docker-compose logs -f

# Follow specific service
docker-compose logs -f backend
```

## 🚀 Production Deployment

For production deployment, consider:
1. Using environment variables for sensitive data
2. Setting up proper SSL certificates
3. Using a reverse proxy (nginx/traefik)
4. Setting up monitoring and logging
5. Using Docker Swarm or Kubernetes for orchestration

## 📞 Support

If you encounter any issues:
1. Check the logs: `docker-compose logs -f`
2. Verify all services are running: `docker-compose ps`
3. Check port availability
4. Restart services: `docker-compose restart`

---

**🎉 Enjoy your complete healthcare management system!**
