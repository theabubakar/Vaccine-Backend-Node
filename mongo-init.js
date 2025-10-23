// MongoDB initialization script
db = db.getSiblingDB('vaccine_management');

// Create application user
db.createUser({
  user: 'vaccine_user',
  pwd: 'vaccine_password',
  roles: [
    {
      role: 'readWrite',
      db: 'vaccine_management'
    }
  ]
});

// Create collections with initial indexes
db.createCollection('vaccines');
db.createCollection('doses');
db.createCollection('brands');
db.createCollection('doctors');

// Create indexes for better performance
db.vaccines.createIndex({ vaccineID: 1 }, { unique: true });
db.doses.createIndex({ doseId: 1 }, { unique: true });
db.brands.createIndex({ brandId: 1 }, { unique: true });
db.doctors.createIndex({ doctorId: 1 }, { unique: true });
db.doctors.createIndex({ email: 1 }, { unique: true });
db.doctors.createIndex({ mobileNumber: 1 }, { unique: true });

print('Database initialized successfully!');
