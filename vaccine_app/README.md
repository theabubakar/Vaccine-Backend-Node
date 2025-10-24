# Vaccine Management System - Flutter Frontend

A modern Flutter web application for managing vaccines, doses, brands, and doctors with a professional admin dashboard.

## 🚀 Quick Start with Docker

### Prerequisites

- Docker installed
- Git

### 1. Using Docker Compose (Recommended)

From the root directory:

```bash
# Start all services including this Flutter app
docker-compose up -d

# Access the app at http://localhost:8081
```

### 2. Standalone Docker Build

```bash
# Build the Flutter web app
docker build -t vaccine-frontend .

# Run the container
docker run -p 8081:80 vaccine-frontend

# Access at http://localhost:8081
```

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Web browser (Chrome recommended)

### 1. Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get
```

### 2. Run Development Server

```bash
# Run on web with hot reload
flutter run -d web-server --web-port 8080

# Run with specific browser
flutter run -d chrome --web-port 8080
```

### 3. Build for Production

```bash
# Build optimized web app
flutter build web --release --web-renderer html

# Build with specific renderer
flutter build web --release --web-renderer canvaskit
```

## 📱 Features

### Admin Dashboard
- **Vaccines Management**: Create, edit, delete vaccines with age ranges
- **Doses Management**: Manage vaccine doses with gap requirements
- **Brands Management**: CRUD operations for vaccine brands
- **Doctors Management**: Complete doctor profiles with image upload
- **Professional UI**: Modern, responsive design with dark/light themes

### Key Components
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Image Upload**: Support for doctor profile images (base64)
- **Auto-incrementing IDs**: User-friendly sequential numbering
- **Real-time Updates**: Live data synchronization
- **Professional Cards**: Enhanced UI with status indicators

## 🏗️ Project Structure

```
vaccine_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── vaccine.dart
│   │   ├── dose.dart
│   │   ├── brand.dart
│   │   └── doctor.dart
│   ├── screens/                  # UI screens
│   │   ├── admin_dashboard.dart  # Main dashboard
│   │   ├── vaccine_*.dart        # Vaccine management
│   │   ├── dose_*.dart           # Dose management
│   │   ├── brand_*.dart          # Brand management
│   │   └── doctor_*.dart         # Doctor management
│   ├── services/
│   │   └── api_service.dart      # API communication
│   └── widgets/                  # Reusable widgets
├── web/                          # Web assets
│   ├── index.html
│   ├── manifest.json
│   └── icons/
├── pubspec.yaml                  # Dependencies
├── Dockerfile                    # Docker configuration
└── nginx.conf                    # Nginx configuration
```

## 🔧 Configuration

### API Configuration

The app connects to the backend API. Update the base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://localhost:3000/api';
```

### Docker Configuration

The Docker setup includes:
- **Base Image**: Flutter stable
- **Web Server**: Nginx
- **Port**: 80 (mapped to 8080)
- **Health Check**: Built-in endpoint

## 🐳 Docker Commands

### Build and Run

```bash
# Build the image
docker build -t vaccine-frontend .

# Run container
docker run -d -p 8080:80 --name vaccine-frontend vaccine-frontend

# View logs
docker logs vaccine-frontend

# Stop container
docker stop vaccine-frontend

# Remove container
docker rm vaccine-frontend
```

### Development with Docker

```bash
# Run with volume mount for development
docker run -d -p 8080:80 -v $(pwd):/app vaccine-frontend

# Interactive shell
docker exec -it vaccine-frontend sh
```

## 📊 Dependencies

### Core Dependencies
- `flutter`: SDK
- `http`: API communication
- `provider`: State management
- `shared_preferences`: Local storage
- `image_picker`: Image upload functionality

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code linting

## 🎨 UI/UX Features

### Design System
- **Material Design 3**: Modern Flutter design
- **Responsive Layout**: Adapts to different screen sizes
- **Professional Cards**: Enhanced with shadows and gradients
- **Status Indicators**: Color-coded status badges
- **Image Support**: Base64 and network image handling

### Navigation
- **Sidebar Navigation**: Collapsible admin sidebar
- **Breadcrumbs**: Clear navigation hierarchy
- **Modal Dialogs**: Professional popup dialogs
- **Form Validation**: Real-time input validation

## 🧪 Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Web Testing

```bash
# Test on web
flutter test -d web-server

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 🚀 Deployment

### Production Build

```bash
# Build optimized version
flutter build web --release --web-renderer html

# Build with PWA support
flutter build web --release --pwa-strategy offline-first
```

### Docker Production

```bash
# Build production image
docker build -t vaccine-frontend:latest .

# Run production container
docker run -d -p 8080:80 --restart unless-stopped vaccine-frontend:latest
```

## 🔍 Debugging

### Common Issues

1. **Build Errors**
   ```bash
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter build web --release
   ```

2. **API Connection Issues**
   - Check backend is running on port 3000
   - Verify CORS settings
   - Check network connectivity

3. **Image Upload Issues**
   - Ensure image_picker is properly configured
   - Check file size limits
   - Verify base64 encoding

### Debug Mode

```bash
# Run in debug mode
flutter run -d web-server --web-port 8080 --debug

# Enable verbose logging
flutter run -d web-server --verbose
```

## 📱 Browser Support

- **Chrome**: Full support (recommended)
- **Firefox**: Full support
- **Safari**: Full support
- **Edge**: Full support
- **Mobile Browsers**: Responsive design

## 🔒 Security Features

- **CORS Configuration**: Proper cross-origin setup
- **Input Validation**: Client-side validation
- **Image Sanitization**: Safe image handling
- **XSS Protection**: Built-in Flutter security

## 📈 Performance

### Optimization Features
- **Lazy Loading**: Efficient list rendering
- **Image Caching**: Optimized image handling
- **Gzip Compression**: Nginx compression
- **Static Asset Caching**: Browser caching headers

### Performance Monitoring

```bash
# Analyze bundle size
flutter build web --analyze-size

# Performance profiling
flutter run -d web-server --profile
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation
- Ensure responsive design
- Test on multiple browsers

## 📄 License

This project is part of the Vaccine Management System and follows the same license terms.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Flutter documentation
3. Check browser console for errors
4. Create an issue in the repository