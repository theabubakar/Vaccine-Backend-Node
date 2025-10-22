# Vaccine Management System - Backend

A Node.js backend API for managing vaccines and doses with MongoDB database.

## Features

- **Vaccine Management**: CRUD operations for vaccines
- **Dose Management**: CRUD operations for doses with vaccine relationships
- **MongoDB Integration**: Full database connectivity with validation
- **RESTful API**: Clean and consistent API endpoints

## Database Schema

### Vaccine Collection
- `vaccineID` (String, Unique): Unique identifier for the vaccine
- `name` (String): Name of the vaccine
- `minAge` (Number): Minimum age for vaccination
- `maxAge` (Number): Maximum age for vaccination
- `isInfinite` (Boolean): Whether the vaccine has infinite validity
- `validity` (Boolean): Current validity status (true/false)

### Doses Collection
- `doseId` (String, Unique): Unique identifier for the dose
- `minAge` (Number): Minimum age for this dose
- `maxAge` (Number): Maximum age for this dose
- `minGap` (Number): Minimum gap between doses (in days)
- `vaccineID` (String): Reference to Vaccine collection

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local installation or MongoDB Atlas)
- npm or yarn

## Installation

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Set up MongoDB:**
   - Install MongoDB locally or use MongoDB Atlas
   - Update the `MONGODB_URI` in `config.env` file

3. **Configure environment variables:**
   ```bash
   # config.env
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/vaccine_management
   NODE_ENV=development
   ```

## Running the Application

1. **Development mode (with auto-restart):**
   ```bash
   npm run dev
   ```

2. **Production mode:**
   ```bash
   npm start
   ```

The server will start on `http://localhost:3000`

## API Documentation

### Swagger UI
- **Interactive API Documentation**: http://localhost:3000/api-docs
- **Test APIs directly** from the browser
- **View request/response schemas**
- **Try out all endpoints** with sample data

## API Endpoints

### Health Check
- `GET /api/health` - Check if API is running

### Vaccines
- `GET /api/vaccines` - Get all vaccines
- `GET /api/vaccines/:id` - Get vaccine by ID
- `POST /api/vaccines` - Create new vaccine
- `PUT /api/vaccines/:id` - Update vaccine
- `DELETE /api/vaccines/:id` - Delete vaccine

### Doses
- `GET /api/doses` - Get all doses
- `GET /api/doses/:id` - Get dose by ID
- `GET /api/doses/vaccine/:vaccineId` - Get doses by vaccine ID
- `POST /api/doses` - Create new dose
- `PUT /api/doses/:id` - Update dose
- `DELETE /api/doses/:id` - Delete dose

## Example API Usage

### Create a Vaccine
```bash
POST /api/vaccines
Content-Type: application/json

{
  "vaccineID": "VAC001",
  "name": "COVID-19 Vaccine",
  "minAge": 18,
  "maxAge": 100,
  "isInfinite": false,
  "validity": true
}
```

### Create a Dose
```bash
POST /api/doses
Content-Type: application/json

{
  "doseId": "DOSE001",
  "minAge": 18,
  "maxAge": 100,
  "minGap": 28,
  "vaccineID": "VAC001"
}
```

## MongoDB Setup

### Local MongoDB Installation
1. Download and install MongoDB from [mongodb.com](https://www.mongodb.com/try/download/community)
2. Start MongoDB service
3. The default connection string `mongodb://localhost:27017/vaccine_management` should work

### MongoDB Atlas (Cloud)
1. Create account at [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Create a new cluster
3. Get connection string and update `MONGODB_URI` in `config.env`

## Project Structure
```
├── config/
│   └── database.js          # Database connection
├── models/
│   ├── Vaccine.js           # Vaccine model
│   └── Dose.js              # Dose model
├── routes/
│   ├── vaccineRoutes.js     # Vaccine API routes
│   └── doseRoutes.js        # Dose API routes
├── config.env               # Environment variables
├── package.json             # Dependencies
├── server.js                # Main server file
└── README.md                # This file
```

## MongoDB Atlas Setup

### Quick Setup
1. **Whitelist your IP**: Add `39.58.246.254` to MongoDB Atlas Network Access
2. **Test connection**: Run `node test-atlas-connection.js`
3. **Start server**: Run `npm run dev`

### Detailed Setup
See `MONGODB_ATLAS_SETUP.md` for complete instructions.

## Next Steps

After setting up the backend:
1. **Whitelist your IP** in MongoDB Atlas (see above)
2. **Test APIs** using Swagger UI at http://localhost:3000/api-docs
3. **Set up Flutter frontend** (already created)
4. **Connect Flutter app** to these APIs
5. **Implement user authentication** if needed

## 🎉 What's Ready

✅ **Complete Backend API** with MongoDB Atlas integration  
✅ **Swagger Documentation** for easy API testing  
✅ **Flutter Mobile App** with beautiful UI  
✅ **Database Models** for Vaccines and Doses  
✅ **CRUD Operations** for all entities  
✅ **Error Handling** and validation  