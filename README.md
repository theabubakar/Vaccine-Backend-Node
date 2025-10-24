# Doctor Portal App

This Flutter application serves as the Doctor Portal for the Patient Management System. It allows doctors to log in using their credentials (email/phone number and auto-generated password) created by the Admin Management System.

## Features

- Professional and responsive login screen with form validation
- Secure authentication using tokens
- Integration with the existing Node.js backend API
- Welcome dashboard displaying doctor's profile information
- Quick action buttons for common tasks
- Logout functionality

## Project Structure

```
doctor_portal_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── doctor.dart          # Doctor data model
│   ├── services/
│   │   └── auth_service.dart    # Authentication service
│   └── screens/
│       ├── login_screen.dart    # Beautiful login screen
│       └── dashboard_screen.dart # Welcome dashboard
├── test/
│   └── widget_test.dart         # Basic tests
├── pubspec.yaml                 # Dependencies
└── README.md                    # This file
```

## Setup and Run

### Prerequisites

- Flutter SDK installed (version 3.0.0 or higher recommended)
- Node.js backend running (preferably via Docker as described in the main project README)
- The backend should be accessible at `http://localhost:3000`

### 1. Navigate to the App Directory

```bash
cd doctor_portal_app
```

### 2. Get Dependencies

```bash
flutter pub get
```

### 3. Run the Application

You can run the application on a web server (recommended for quick testing) or on an emulator/device.

#### Option A: Run on Web Server (Port 8082)

```bash
flutter run -d web-server --web-port 8082
```
Access the app in your browser at `http://localhost:8082`.

#### Option B: Run on an Emulator/Device

Ensure you have an Android emulator, iOS simulator, or a physical device connected and configured.

```bash
flutter run
```

## Testing the Login

To test the login functionality:

1. **Ensure your backend is running** (e.g., using `docker-compose up -d` from the main project root)
2. **Access the Admin Management System** at `http://localhost:8081`
3. **Create a new Doctor** account through the Admin Management System. Note down:
   - Email or Mobile Number
   - Auto-generated Password
4. **Use these credentials** in the Doctor Portal App (`http://localhost:8082`) to log in

Upon successful login, you should be redirected to the Doctor Dashboard.

## API Endpoints

The app connects to these backend endpoints:

- `POST /api/auth/login` - Doctor login
- `POST /api/auth/verify` - Token verification

## Development

### Code Structure
- **Models**: Data classes for API responses
- **Services**: API communication and business logic
- **Screens**: UI components and user interactions

### Key Files
- `lib/services/auth_service.dart` - Handles authentication
- `lib/screens/login_screen.dart` - Login UI
- `lib/screens/dashboard_screen.dart` - Dashboard UI

### Adding Features
1. Create new models in `lib/models/`
2. Add API methods in `lib/services/`
3. Create new screens in `lib/screens/`
4. Update navigation in `main.dart`

---

## 🐳 Docker Setup (Recommended)

For the easiest setup experience, use Docker to run all applications:

### Quick Start
```bash
# Start all services with one command
docker-compose up -d --build
```

### Access URLs
- **Backend API**: http://localhost:3000
- **Admin System**: http://localhost:8081
- **Doctor Portal**: http://localhost:8082
- **Patient Panel**: http://localhost:8083

### Test Credentials
- **Doctor 1**: john.smith@hospital.com / Doc123!@#
- **Doctor 2**: sarah.johnson@clinic.com / Doc456!@#
- **Doctor 3**: michael.brown@medical.com / Doc789!@#

For detailed Docker setup instructions, see [DOCKER_SETUP.md](DOCKER_SETUP.md)

---

## 🚀 Manual Setup (Alternative)

If you prefer to run applications manually:

### Backend Setup
```bash
npm install
npm start
```

### Flutter Apps Setup
```bash
# Add Flutter to PATH (Windows)
$env:PATH += ";C:\src\flutter\bin"

# Run Admin System
cd vaccine_app
flutter run -d web-server --web-port 8081

# Run Doctor Portal
cd doctor_portal_app
flutter run -d web-server --web-port 8082

# Run Patient Panel
cd patient_panel
flutter run -d web-server --web-port 8083
```

---

**Note**: This system includes a complete healthcare management platform with admin, doctor, and patient interfaces. The Docker setup includes seed data for immediate testing.
