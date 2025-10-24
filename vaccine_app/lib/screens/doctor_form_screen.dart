import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/doctor.dart';
import '../services/api_service.dart';

class DoctorFormScreen extends StatefulWidget {
  final Doctor? doctor;

  const DoctorFormScreen({super.key, this.doctor});

  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _typeController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imageController = TextEditingController();
  final _pmdcController = TextEditingController();
  
  bool _isLoading = false;
  bool _isActive = true;
  bool _isEditMode = false;
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.doctor != null;
    
    if (_isEditMode) {
      _firstNameController.text = widget.doctor!.firstName;
      _lastNameController.text = widget.doctor!.lastName;
      _emailController.text = widget.doctor!.email;
      _mobileController.text = widget.doctor!.mobileNumber;
      _typeController.text = widget.doctor!.type ?? '';
      _qualificationsController.text = widget.doctor!.qualifications ?? '';
      _additionalInfoController.text = widget.doctor!.additionalInfo ?? '';
      _passwordController.text = widget.doctor!.password ?? '';
      _imageController.text = widget.doctor!.image ?? '';
      _pmdcController.text = widget.doctor!.pmdc ?? '';
      _isActive = widget.doctor!.isActive;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _typeController.dispose();
    _qualificationsController.dispose();
    _additionalInfoController.dispose();
    _passwordController.dispose();
    _imageController.dispose();
    _pmdcController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        final dataUrl = 'data:image/jpeg;base64,$base64String';
        
        setState(() {
          if (kIsWeb) {
            _selectedImageBytes = bytes;
            _selectedImage = null;
          } else {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
          }
          _imageController.text = dataUrl; // Store as base64 data URL
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        final dataUrl = 'data:image/jpeg;base64,$base64String';
        
        setState(() {
          if (kIsWeb) {
            _selectedImageBytes = bytes;
            _selectedImage = null;
          } else {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
          }
          _imageController.text = dataUrl; // Store as base64 data URL
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveDoctor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final doctor = Doctor(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        type: _typeController.text.trim().isEmpty ? null : _typeController.text.trim(),
        qualifications: _qualificationsController.text.trim().isEmpty ? null : _qualificationsController.text.trim(),
        additionalInfo: _additionalInfoController.text.trim().isEmpty ? null : _additionalInfoController.text.trim(),
        password: _isEditMode ? null : _passwordController.text.trim().isEmpty ? null : _passwordController.text.trim(),
        image: _imageController.text.trim().isEmpty ? null : _imageController.text.trim(),
        pmdc: _pmdcController.text.trim().isEmpty ? null : _pmdcController.text.trim(),
        isActive: _isActive,
      );

      if (_isEditMode && widget.doctor!.id != null) {
        // Update existing doctor
        await ApiService.updateDoctor(widget.doctor!.id!, doctor);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Doctor updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        // Create new doctor
        final result = await ApiService.createDoctor(doctor);
        if (mounted) {
          // Show the generated password dialog
          _showGeneratedPasswordDialog(result['generatedPassword']);
          return; // Don't navigate back yet, let the dialog handle it
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showGeneratedPasswordDialog(String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Doctor Created Successfully'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The doctor has been created with the following auto-generated password:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        password,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: password));
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Password copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please save this password securely and share it with the doctor.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                Navigator.of(context).pop(true); // Close form screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImagePreview() {
    // Show selected image (web or mobile)
    if (kIsWeb && _selectedImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          _selectedImageBytes!,
          fit: BoxFit.cover,
        ),
      );
    } else if (!kIsWeb && _selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      );
    }
    
    // Show image from URL field (including base64 data URLs)
    if (_imageController.text.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _imageController.text.startsWith('data:')
            ? Image.memory(
                base64Decode(_imageController.text.split(',')[1]),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 40);
                },
              )
            : Image.network(
                _imageController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 40);
                },
              ),
      );
    }
    
    // Show existing doctor image from URL
    if (widget.doctor?.image != null && widget.doctor!.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: widget.doctor!.image!.startsWith('data:')
            ? Image.memory(
                base64Decode(widget.doctor!.image!.split(',')[1]),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 40);
                },
              )
            : Image.network(
                widget.doctor!.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 40);
                },
              ),
      );
    }
    
    // Default icon
    return const Icon(Icons.person, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Doctor' : 'Add Doctor'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Card
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name *',
                                hintText: 'Enter first name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name *',
                                hintText: 'Enter last name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          hintText: 'Enter email address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number *',
                          hintText: 'Enter mobile number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Professional Information Card (only for edit mode)
              if (_isEditMode) ...[
                Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Professional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _typeController,
                          decoration: const InputDecoration(
                            labelText: 'Type/Specialization',
                            hintText: 'e.g., Cardiologist, General Physician',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.medical_services),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _qualificationsController,
                          decoration: const InputDecoration(
                            labelText: 'Qualifications',
                            hintText: 'e.g., MBBS, MD, PhD',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.school),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pmdcController,
                          decoration: const InputDecoration(
                            labelText: 'PMDC Number',
                            hintText: 'Enter PMDC registration number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _additionalInfoController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Additional Information',
                            hintText: 'Any additional information about the doctor',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.info_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Image Upload Section
                        Row(
                          children: [
                            const Text(
                              'Profile Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (kIsWeb) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Web Mode',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Image Preview
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _buildImagePreview(),
                            ),
                            const SizedBox(width: 16),
                            // Upload Buttons
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _pickImage,
                                      icon: const Icon(Icons.photo_library, size: 18),
                                      label: const Text('Gallery'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[100],
                                        foregroundColor: Colors.blue[700],
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: kIsWeb ? null : _takePhoto,
                                      icon: const Icon(Icons.camera_alt, size: 18),
                                      label: Text(kIsWeb ? 'Camera (N/A)' : 'Camera'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kIsWeb ? Colors.grey[100] : Colors.green[100],
                                        foregroundColor: kIsWeb ? Colors.grey[500] : Colors.green[700],
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // URL Input (Alternative)
                        TextFormField(
                          controller: _imageController,
                          decoration: const InputDecoration(
                            labelText: 'Or enter image URL',
                            hintText: 'Enter profile image URL (or upload above)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.link),
                          ),
                          onChanged: (value) {
                            // Clear selected image when URL is manually entered
                            if (value.isNotEmpty && !value.startsWith('data:')) {
                              setState(() {
                                _selectedImage = null;
                                _selectedImageBytes = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _isActive,
                              onChanged: (value) {
                                setState(() {
                                  _isActive = value ?? true;
                                });
                              },
                            ),
                            const Text('Active Status'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveDoctor,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(_isEditMode ? Icons.save : Icons.add),
                  label: Text(_isEditMode ? 'Update Doctor' : 'Create Doctor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
