# Vaccine Management System

A comprehensive vaccine management system built with Flutter (frontend) and Node.js (backend) with MongoDB database.

## 🏗️ Architecture

- **Frontend**: Flutter Web App (Admin Dashboard)
- **Backend**: Node.js + Express API
- **Database**: MongoDB
- **Containerization**: Docker & Docker Compose

## 🚀 Quick Start with Docker

### Prerequisites

- Docker and Docker Compose installed
- Git

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Vaccine-Flutter-Node
```

### 2. Start All Services

```bash
# Start all services (MongoDB, Backend, Frontend)
docker-compose up -d

# View logs
docker-compose logs -f
```

### 3. Access the Application

- **Frontend (Flutter Web)**: http://localhost:8081
- **Backend API**: http://localhost:3000
- **API Documentation**: http://localhost:3000/api-docs
- **MongoDB**: localhost:27017

### 4. Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: This will delete all data)
docker-compose down -v
```

## 📋 Available Services

| Service | Port | Description |
|---------|------|-------------|
| Frontend | 8081 | Flutter Web Admin Dashboard |
| Backend | 3000 | Node.js API Server |
| MongoDB | 27017 | Database Server |
| API Docs | 3000/api-docs | Swagger Documentation |

## 🛠️ Development Setup

### Backend Development

```bash
# Navigate to backend directory
cd .

# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

### Frontend Development

```bash
# Navigate to Flutter app directory
cd vaccine_app

# Install Flutter dependencies
flutter pub get

# Run in development mode
flutter run -d web-server --web-port 8081

# Build for production
flutter build web --release
```

## 📊 API Endpoints

### Vaccines
- `GET /api/vaccines` - Get all vaccines
- `POST /api/vaccines` - Create new vaccine
- `PUT /api/vaccines/:id` - Update vaccine
- `DELETE /api/vaccines/:id` - Delete vaccine

### Doses
- `GET /api/doses` - Get all doses
- `GET /api/doses/vaccine/:vaccineId` - Get doses by vaccine
- `POST /api/doses` - Create new dose
- `PUT /api/doses/:id` - Update dose
- `DELETE /api/doses/:id` - Delete dose

### Brands
- `GET /api/brands` - Get all brands
- `POST /api/brands` - Create new brand
- `PUT /api/brands/:id` - Update brand
- `DELETE /api/brands/:id` - Delete brand

### Doctors
- `GET /api/doctors` - Get all doctors
- `POST /api/doctors` - Create new doctor
- `PUT /api/doctors/:id` - Update doctor
- `DELETE /api/doctors/:id` - Delete doctor

## 🗄️ Database Schema

### MongoDB Collections

- **vaccines**: Vaccine information with auto-incrementing IDs
- **doses**: Dose details linked to vaccines
- **brands**: Brand management
- **doctors**: Doctor profiles with image support

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://admin:password123@mongodb:27017/vaccine_management?authSource=admin
```

### Docker Environment

The Docker setup uses these default configurations:
- MongoDB: `admin/password123`
- Database: `vaccine_management`
- Backend Port: `3000`
- Frontend Port: `8080`

## 🐳 Docker Commands

### Individual Services

```bash
# Build and run backend only
docker build -t vaccine-backend .
docker run -p 3000:3000 vaccine-backend

# Build and run frontend only
cd vaccine_app
docker build -t vaccine-frontend .
docker run -p 8080:80 vaccine-frontend

# Run MongoDB only
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```

### Docker Compose Commands

```bash
# Start specific service
docker-compose up -d backend

# Rebuild and start
docker-compose up -d --build

# View service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongodb

# Scale services
docker-compose up -d --scale backend=2
```

## 🧪 Testing

### Backend API Testing

```bash
# Test API endpoints
curl http://localhost:3000/api/vaccines
curl http://localhost:3000/api/doctors
```

### Health Checks

```bash
# Check backend health
curl http://localhost:3000/api

# Check frontend health
curl http://localhost:8080/health
```

## 📁 Project Structure

```
Vaccine-Flutter-Node/
├── docker-compose.yml          # Main Docker Compose file
├── Dockerfile                  # Backend Dockerfile
├── mongo-init.js              # MongoDB initialization
├── package.json               # Backend dependencies
├── server.js                  # Backend entry point
├── models/                    # Database models
├── routes/                    # API routes
├── config/                    # Configuration files
└── vaccine_app/               # Flutter frontend
    ├── Dockerfile             # Frontend Dockerfile
    ├── nginx.conf             # Nginx configuration
    ├── lib/                   # Flutter source code
    ├── web/                   # Web assets
    └── pubspec.yaml           # Flutter dependencies
```

## 🚨 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using the port
   netstat -tulpn | grep :3000
   
   # Kill the process
   sudo kill -9 <PID>
   ```

2. **MongoDB connection issues**
   ```bash
   # Check MongoDB logs
   docker-compose logs mongodb
   
   # Restart MongoDB
   docker-compose restart mongodb
   ```

3. **Flutter build issues**
   ```bash
   # Clean Flutter build
   cd vaccine_app
   flutter clean
   flutter pub get
   flutter build web --release
   ```

4. **Docker build cache issues**
   ```bash
   # Rebuild without cache
   docker-compose build --no-cache
   ```

## 📝 Development Notes

- The system uses auto-incrementing IDs for better user experience
- Images are stored as base64 data URLs for simplicity
- Password generation is automatic for doctors
- The admin dashboard provides full CRUD operations
- All API endpoints are documented with Swagger

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Docker
5. Submit a pull request

## 📄 License

This project is licensed under the ISC License.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Docker logs
3. Check API documentation at `/api-docs`
4. Create an issue in the repository