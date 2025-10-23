# Development Guide - Vaccine Management System

This guide provides comprehensive instructions for developers to set up, develop, and contribute to the Vaccine Management System.

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

**Windows:**
```cmd
setup.bat
```

**Linux/macOS:**
```bash
./setup.sh
```

### Option 2: Manual Setup

```bash
# Clone repository
git clone <repository-url>
cd Vaccine-Flutter-Node

# Start all services
docker-compose up -d

# Access the application
# Frontend: http://localhost:8080
# Backend: http://localhost:3000
# API Docs: http://localhost:3000/api-docs
```

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter Web   │    │   Node.js API   │    │    MongoDB      │
│   (Frontend)    │◄──►│   (Backend)     │◄──►│   (Database)    │
│   Port: 8080    │    │   Port: 3000    │    │   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🛠️ Development Environment

### Prerequisites

- **Docker & Docker Compose**: For containerized development
- **Node.js 18+**: For backend development
- **Flutter SDK 3.0+**: For frontend development
- **Git**: For version control

### Development Modes

#### 1. Full Docker Development
```bash
# Start all services in containers
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

#### 2. Hybrid Development (Backend in Docker, Frontend Local)
```bash
# Start only backend services
docker-compose up -d mongodb backend

# Run Flutter locally
cd vaccine_app
flutter run -d web-server --web-port 8080
```

#### 3. Local Development
```bash
# Start MongoDB in Docker
docker run -d -p 27017:27017 --name mongodb mongo:7.0

# Run backend locally
npm install
npm run dev

# Run frontend locally
cd vaccine_app
flutter pub get
flutter run -d web-server --web-port 8080
```

## 📁 Project Structure

```
Vaccine-Flutter-Node/
├── 📄 README.md                    # Main project documentation
├── 📄 DEVELOPMENT_GUIDE.md         # This file
├── 🐳 docker-compose.yml           # Production Docker setup
├── 🐳 docker-compose.dev.yml       # Development Docker setup
├── 🐳 Dockerfile                   # Backend production image
├── 🐳 Dockerfile.dev               # Backend development image
├── 🐳 mongo-init.js                # MongoDB initialization
├── 🔧 setup.sh / setup.bat         # Automated setup scripts
├── 📦 package.json                 # Backend dependencies
├── 🚀 server.js                    # Backend entry point
├── 📁 models/                      # Database models
│   ├── Vaccine.js
│   ├── Dose.js
│   ├── Brand.js
│   └── Doctor.js
├── 📁 routes/                      # API routes
│   ├── vaccineRoutes.js
│   ├── doseRoutes.js
│   ├── brandRoutes.js
│   └── doctorRoutes.js
├── 📁 config/                      # Configuration files
│   ├── database.js
│   └── swagger.js
└── 📁 vaccine_app/                 # Flutter frontend
    ├── 📄 README.md                # Frontend documentation
    ├── 🐳 Dockerfile               # Frontend Docker image
    ├── 🐳 nginx.conf               # Nginx configuration
    ├── 📦 pubspec.yaml             # Flutter dependencies
    ├── 📁 lib/                     # Flutter source code
    │   ├── main.dart
    │   ├── models/                 # Data models
    │   ├── screens/                # UI screens
    │   ├── services/               # API services
    │   └── widgets/                # Reusable widgets
    └── 📁 web/                     # Web assets
```

## 🔧 Backend Development

### API Structure

The backend follows RESTful API principles with the following endpoints:

#### Vaccines API
- `GET /api/vaccines` - List all vaccines
- `POST /api/vaccines` - Create new vaccine
- `GET /api/vaccines/:id` - Get vaccine by ID
- `PUT /api/vaccines/:id` - Update vaccine
- `DELETE /api/vaccines/:id` - Delete vaccine

#### Doses API
- `GET /api/doses` - List all doses
- `GET /api/doses/vaccine/:vaccineId` - Get doses by vaccine
- `POST /api/doses` - Create new dose
- `PUT /api/doses/:id` - Update dose
- `DELETE /api/doses/:id` - Delete dose

#### Brands API
- `GET /api/brands` - List all brands
- `POST /api/brands` - Create new brand
- `PUT /api/brands/:id` - Update brand
- `DELETE /api/brands/:id` - Delete brand

#### Doctors API
- `GET /api/doctors` - List all doctors
- `POST /api/doctors` - Create new doctor
- `PUT /api/doctors/:id` - Update doctor
- `DELETE /api/doctors/:id` - Delete doctor

### Database Models

#### Vaccine Model
```javascript
{
  vaccineID: Number,    // Auto-incrementing ID
  name: String,         // Vaccine name
  minAge: Number,       // Minimum age
  maxAge: Number,       // Maximum age
  isInfinite: Boolean,  // No age limit
  validity: Boolean     // Active status
}
```

#### Dose Model
```javascript
{
  doseId: Number,       // Auto-incrementing ID
  name: String,         // Dose name (optional)
  minAge: Number,       // Minimum age
  maxAge: Number,       // Maximum age
  minGap: Number,       // Minimum gap between doses
  vaccineID: ObjectId   // Reference to vaccine (optional)
}
```

#### Brand Model
```javascript
{
  brandId: Number,      // Auto-incrementing ID
  name: String          // Brand name
}
```

#### Doctor Model
```javascript
{
  doctorId: Number,     // Auto-incrementing ID
  firstName: String,    // First name
  lastName: String,     // Last name
  email: String,        // Email (unique)
  mobileNumber: String, // Mobile (unique)
  type: String,         // Specialization
  qualifications: String, // Qualifications
  additionalInfo: String, // Additional info
  password: String,     // Auto-generated
  image: String,        // Base64 image data
  pmdc: String,         // PMDC number
  isActive: Boolean     // Active status
}
```

### Development Commands

```bash
# Install dependencies
npm install

# Start development server with hot reload
npm run dev

# Start production server
npm start

# View API documentation
# Visit: http://localhost:3000/api-docs
```

## 📱 Frontend Development

### Flutter App Structure

The Flutter app is organized into the following structure:

#### Models (`lib/models/`)
- Data models that mirror the backend API
- JSON serialization/deserialization
- Type safety and validation

#### Screens (`lib/screens/`)
- `admin_dashboard.dart` - Main dashboard
- `vaccine_*.dart` - Vaccine management screens
- `dose_*.dart` - Dose management screens
- `brand_*.dart` - Brand management screens
- `doctor_*.dart` - Doctor management screens

#### Services (`lib/services/`)
- `api_service.dart` - Centralized API communication
- HTTP client configuration
- Error handling and response parsing

### Development Commands

```bash
# Navigate to Flutter app
cd vaccine_app

# Install dependencies
flutter pub get

# Run in development mode
flutter run -d web-server --web-port 8080

# Run with hot reload
flutter run -d web-server --web-port 8080 --hot

# Build for production
flutter build web --release

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Key Features

#### State Management
- Provider pattern for state management
- Reactive UI updates
- Efficient data flow

#### UI/UX Features
- Material Design 3
- Responsive design
- Professional admin dashboard
- Image upload support
- Form validation
- Error handling

#### API Integration
- RESTful API communication
- Error handling and retry logic
- Loading states
- Offline support considerations

## 🐳 Docker Development

### Development Docker Compose

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop development environment
docker-compose -f docker-compose.dev.yml down
```

### Production Docker Compose

```bash
# Start production environment
docker-compose up -d

# View logs
docker-compose logs -f

# Stop production environment
docker-compose down
```

### Docker Commands

```bash
# Build specific service
docker-compose build backend
docker-compose build frontend

# Rebuild and restart
docker-compose up -d --build

# View service status
docker-compose ps

# Execute commands in containers
docker-compose exec backend sh
docker-compose exec mongodb mongosh
```

## 🧪 Testing

### Backend Testing

```bash
# Run backend tests (when implemented)
npm test

# Test API endpoints manually
curl http://localhost:3000/api/vaccines
curl http://localhost:3000/api/doctors
```

### Frontend Testing

```bash
# Run Flutter tests
cd vaccine_app
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Test with coverage
flutter test --coverage
```

### End-to-End Testing

```bash
# Test complete workflow
# 1. Start all services
docker-compose up -d

# 2. Test frontend
curl http://localhost:8080

# 3. Test backend
curl http://localhost:3000/api

# 4. Test database connection
docker-compose exec mongodb mongosh --eval "db.runCommand('ping')"
```

## 🔍 Debugging

### Backend Debugging

```bash
# View backend logs
docker-compose logs backend

# Debug with Node.js inspector
docker-compose exec backend node --inspect=0.0.0.0:9229 server.js

# Connect debugger to localhost:9229
```

### Frontend Debugging

```bash
# Run Flutter in debug mode
cd vaccine_app
flutter run -d web-server --web-port 8080 --debug

# Enable verbose logging
flutter run -d web-server --verbose

# Debug in browser
# Open Chrome DevTools and use Flutter Inspector
```

### Database Debugging

```bash
# Connect to MongoDB
docker-compose exec mongodb mongosh

# View collections
use vaccine_management
show collections

# Query data
db.vaccines.find()
db.doctors.find()
```

## 🚀 Deployment

### Production Deployment

```bash
# Build production images
docker-compose build

# Start production services
docker-compose up -d

# Verify deployment
curl http://localhost:8080
curl http://localhost:3000/api
```

### Environment Configuration

Create production `.env` file:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://admin:secure_password@mongodb:27017/vaccine_management?authSource=admin
```

### Security Considerations

- Change default MongoDB credentials
- Use environment variables for sensitive data
- Enable HTTPS in production
- Configure CORS properly
- Implement rate limiting
- Add authentication/authorization

## 📝 Code Standards

### Backend Standards

- Use ES6+ JavaScript features
- Follow RESTful API conventions
- Implement proper error handling
- Add input validation
- Use meaningful variable names
- Add JSDoc comments for functions

### Frontend Standards

- Follow Flutter/Dart style guidelines
- Use meaningful widget names
- Implement proper error handling
- Add comments for complex logic
- Use const constructors where possible
- Follow Material Design guidelines

### Git Standards

- Use descriptive commit messages
- Create feature branches
- Use pull requests for code review
- Keep commits atomic
- Update documentation with changes

## 🤝 Contributing

### Development Workflow

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/new-feature
   ```
3. **Make your changes**
4. **Test thoroughly**
   ```bash
   # Test backend
   npm test
   
   # Test frontend
   cd vaccine_app
   flutter test
   ```
5. **Commit your changes**
   ```bash
   git commit -m "Add new feature: description"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/new-feature
   ```
7. **Create a pull request**

### Code Review Process

- All code must be reviewed before merging
- Tests must pass
- Documentation must be updated
- Code must follow style guidelines
- Security implications must be considered

## 🆘 Troubleshooting

### Common Issues

#### Docker Issues
```bash
# Clean Docker system
docker system prune -f

# Rebuild without cache
docker-compose build --no-cache

# Check Docker logs
docker-compose logs
```

#### MongoDB Issues
```bash
# Reset MongoDB data
docker-compose down -v
docker-compose up -d

# Check MongoDB logs
docker-compose logs mongodb
```

#### Flutter Issues
```bash
# Clean Flutter build
cd vaccine_app
flutter clean
flutter pub get
flutter build web --release
```

#### API Issues
```bash
# Check API health
curl http://localhost:3000/api

# Check API documentation
# Visit: http://localhost:3000/api-docs
```

### Getting Help

1. Check this development guide
2. Review the main README files
3. Check Docker and service logs
4. Search existing issues
5. Create a new issue with detailed information

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Node.js Documentation](https://nodejs.org/docs)
- [MongoDB Documentation](https://docs.mongodb.com)
- [Docker Documentation](https://docs.docker.com)
- [Material Design Guidelines](https://material.io/design)
- [RESTful API Design](https://restfulapi.net)

---

Happy coding! 🚀
