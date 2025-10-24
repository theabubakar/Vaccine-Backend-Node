// Seed data for testing the complete system
db = db.getSiblingDB('vaccine_management');

// Clear existing data
db.vaccines.deleteMany({});
db.doses.deleteMany({});
db.brands.deleteMany({});
db.doctors.deleteMany({});
db.clinics.deleteMany({});

print('🌱 Starting database seeding...');

// Seed Brands
const brands = [
  { brandId: 1, name: "Pfizer" },
  { brandId: 2, name: "Moderna" },
  { brandId: 3, name: "Johnson & Johnson" },
  { brandId: 4, name: "AstraZeneca" },
  { brandId: 5, name: "Novavax" }
];

db.brands.insertMany(brands);
print('✅ Brands seeded: ' + brands.length);

// Seed Vaccines
const vaccines = [
  {
    vaccineID: 1,
    name: "COVID-19 Vaccine",
    description: "Protects against COVID-19 infection",
    minAge: 12,
    maxAge: 100,
    brandId: 1,
    isActive: true
  },
  {
    vaccineID: 2,
    name: "Flu Vaccine",
    description: "Annual influenza vaccination",
    minAge: 6,
    maxAge: 100,
    brandId: 2,
    isActive: true
  },
  {
    vaccineID: 3,
    name: "Hepatitis B Vaccine",
    description: "Protects against Hepatitis B",
    minAge: 0,
    maxAge: 100,
    brandId: 3,
    isActive: true
  },
  {
    vaccineID: 4,
    name: "MMR Vaccine",
    description: "Measles, Mumps, and Rubella vaccine",
    minAge: 12,
    maxAge: 65,
    brandId: 4,
    isActive: true
  }
];

db.vaccines.insertMany(vaccines);
print('✅ Vaccines seeded: ' + vaccines.length);

// Seed Doses
const doses = [
  {
    doseId: 1,
    name: "First Dose",
    description: "Initial vaccination dose",
    minAge: 12,
    maxAge: 100,
    minGap: 0,
    vaccineID: 1,
    isActive: true
  },
  {
    doseId: 2,
    name: "Second Dose",
    description: "Booster vaccination dose",
    minAge: 12,
    maxAge: 100,
    minGap: 21,
    vaccineID: 1,
    isActive: true
  },
  {
    doseId: 3,
    name: "Annual Flu Shot",
    description: "Yearly influenza vaccination",
    minAge: 6,
    maxAge: 100,
    minGap: 365,
    vaccineID: 2,
    isActive: true
  },
  {
    doseId: 4,
    name: "Hepatitis B Primary",
    description: "Primary Hepatitis B vaccination",
    minAge: 0,
    maxAge: 100,
    minGap: 0,
    vaccineID: 3,
    isActive: true
  }
];

db.doses.insertMany(doses);
print('✅ Doses seeded: ' + doses.length);

// Seed Doctors
const doctors = [
  {
    doctorId: 1,
    firstName: "John",
    lastName: "Smith",
    email: "john.smith@hospital.com",
    mobileNumber: "+1234567890",
    type: "General Practitioner",
    qualifications: "MD, Internal Medicine",
    additionalInfo: "Specializes in preventive care",
    password: "Doc123!@#",
    image: "",
    PMDC: "PMDC12345",
    isActive: true
  },
  {
    doctorId: 2,
    firstName: "Sarah",
    lastName: "Johnson",
    email: "sarah.johnson@clinic.com",
    mobileNumber: "+1234567891",
    type: "Pediatrician",
    qualifications: "MD, Pediatrics",
    additionalInfo: "Expert in child healthcare",
    password: "Doc456!@#",
    image: "",
    PMDC: "PMDC12346",
    isActive: true
  },
  {
    doctorId: 3,
    firstName: "Michael",
    lastName: "Brown",
    email: "michael.brown@medical.com",
    mobileNumber: "+1234567892",
    type: "Cardiologist",
    qualifications: "MD, Cardiology",
    additionalInfo: "Heart specialist with 15 years experience",
    password: "Doc789!@#",
    image: "",
    PMDC: "PMDC12347",
    isActive: true
  }
];

db.doctors.insertMany(doctors);
print('✅ Doctors seeded: ' + doctors.length);

// Get doctor IDs for clinic seeding
const doctorIds = db.doctors.find({}, { _id: 1 }).toArray();

// Seed Clinics
const clinics = [
  {
    clinicId: 1,
    name: "City Medical Center",
    address: "123 Main Street, Downtown",
    regNo: "CMC001",
    logo: "",
    phoneNumber: "+1234567890",
    clinicFee: 150,
    doctor: doctorIds[0]._id,
    isActive: true
  },
  {
    clinicId: 2,
    name: "Children's Health Clinic",
    address: "456 Oak Avenue, Suburb",
    regNo: "CHC002",
    logo: "",
    phoneNumber: "+1234567891",
    clinicFee: 120,
    doctor: doctorIds[1]._id,
    isActive: true
  },
  {
    clinicId: 3,
    name: "Heart Care Specialists",
    address: "789 Pine Road, Medical District",
    regNo: "HCS003",
    logo: "",
    phoneNumber: "+1234567892",
    clinicFee: 200,
    doctor: doctorIds[2]._id,
    isActive: true
  },
  {
    clinicId: 4,
    name: "Dr. Smith's Private Practice",
    address: "321 Elm Street, Residential Area",
    regNo: "DSP004",
    logo: "",
    phoneNumber: "+1234567893",
    clinicFee: 180,
    doctor: doctorIds[0]._id,
    isActive: true
  }
];

db.clinics.insertMany(clinics);
print('✅ Clinics seeded: ' + clinics.length);

// Create indexes for better performance
db.vaccines.createIndex({ vaccineID: 1 });
db.doses.createIndex({ doseId: 1 });
db.brands.createIndex({ brandId: 1 });
db.doctors.createIndex({ doctorId: 1 });
db.doctors.createIndex({ email: 1 });
db.doctors.createIndex({ mobileNumber: 1 });
db.clinics.createIndex({ clinicId: 1 });
db.clinics.createIndex({ doctor: 1 });
db.clinics.createIndex({ regNo: 1 });

print('✅ Indexes created');

// Display summary
print('\n🎉 Database seeding completed successfully!');
print('📊 Summary:');
print('   - Brands: ' + db.brands.countDocuments());
print('   - Vaccines: ' + db.vaccines.countDocuments());
print('   - Doses: ' + db.doses.countDocuments());
print('   - Doctors: ' + db.doctors.countDocuments());
print('   - Clinics: ' + db.clinics.countDocuments());

print('\n🔑 Test Credentials:');
print('   Doctor 1: john.smith@hospital.com / Doc123!@#');
print('   Doctor 2: sarah.johnson@clinic.com / Doc456!@#');
print('   Doctor 3: michael.brown@medical.com / Doc789!@#');

print('\n🌐 Access URLs:');
print('   - Backend API: http://localhost:3000');
print('   - Admin System: http://localhost:8081');
print('   - Doctor Portal: http://localhost:8082');
print('   - Patient Panel: http://localhost:8083');
