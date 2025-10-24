import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clinic.dart';
import '../services/clinic_service.dart';
import '../services/auth_service.dart';

class ClinicFormScreen extends StatefulWidget {
  final Clinic? clinic;
  final bool isEditMode;

  const ClinicFormScreen({
    Key? key,
    this.clinic,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<ClinicFormScreen> createState() => _ClinicFormScreenState();
}

class _ClinicFormScreenState extends State<ClinicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _regNoController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feeController = TextEditingController();
  final _logoController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.clinic != null) {
      _nameController.text = widget.clinic!.name;
      _addressController.text = widget.clinic!.address;
      _regNoController.text = widget.clinic!.regNo;
      _phoneController.text = widget.clinic!.phoneNumber;
      _feeController.text = widget.clinic!.clinicFee.toString();
      _logoController.text = widget.clinic!.logo ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _regNoController.dispose();
    _phoneController.dispose();
    _feeController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _saveClinic() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final doctor = authService.currentDoctor;
      
      if (doctor == null) {
        _showErrorSnackBar('Doctor not found. Please login again.');
        return;
      }

      final clinic = Clinic(
        id: widget.clinic?.id ?? '',
        clinicId: widget.clinic?.clinicId ?? 0,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        regNo: _regNoController.text.trim(),
        logo: _logoController.text.trim().isEmpty ? null : _logoController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        clinicFee: double.parse(_feeController.text.trim()),
        doctorId: doctor.id,
        isActive: true,
        createdAt: widget.clinic?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Map<String, dynamic> result;
      
      if (widget.isEditMode) {
        result = await ClinicService.updateClinic(clinic.id, clinic);
      } else {
        result = await ClinicService.createClinic(clinic);
      }

      if (result['success']) {
        _showSuccessSnackBar(result['message']);
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        _showErrorSnackBar(result['message']);
      }
    } catch (error) {
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Clinic' : 'Add Clinic'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.blue.shade700,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.isEditMode ? 'Update Clinic Information' : 'Add Your Clinic',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.isEditMode 
                                        ? 'Update your clinic details below'
                                        : 'Fill in your clinic information to get started',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Form Fields
                _buildFormField(
                  controller: _nameController,
                  label: 'Clinic Name',
                  hint: 'Enter your clinic name',
                  icon: Icons.business,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter clinic name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildFormField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter complete clinic address',
                  icon: Icons.location_on,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter clinic address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        controller: _regNoController,
                        label: 'Registration Number',
                        hint: 'Enter registration number',
                        icon: Icons.assignment,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter registration number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: 'Enter phone number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildFormField(
                  controller: _feeController,
                  label: 'Consultation Fee',
                  hint: 'Enter consultation fee',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter consultation fee';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid amount';
                    }
                    if (double.parse(value.trim()) < 0) {
                      return 'Fee cannot be negative';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildFormField(
                  controller: _logoController,
                  label: 'Logo URL (Optional)',
                  hint: 'Enter logo image URL',
                  icon: Icons.image,
                  validator: (value) {
                    // Optional field, no validation needed
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveClinic,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            widget.isEditMode ? 'Update Clinic' : 'Create Clinic',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }
}
