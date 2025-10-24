import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/vaccine.dart';
import '../services/api_service.dart';

class VaccineFormScreen extends StatefulWidget {
  final Vaccine? vaccine;

  const VaccineFormScreen({super.key, this.vaccine});

  @override
  State<VaccineFormScreen> createState() => _VaccineFormScreenState();
}

class _VaccineFormScreenState extends State<VaccineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();
  
  bool _isInfinite = false;
  bool _validity = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.vaccine != null) {
      _nameController.text = widget.vaccine!.name;
      _minAgeController.text = widget.vaccine!.minAge.toString();
      _maxAgeController.text = widget.vaccine!.maxAge.toString();
      _isInfinite = widget.vaccine!.isInfinite;
      _validity = widget.vaccine!.validity;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  Future<void> _saveVaccine() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final vaccine = Vaccine(
        name: _nameController.text.trim(),
        minAge: int.tryParse(_minAgeController.text) ?? 0,
        maxAge: int.tryParse(_maxAgeController.text) ?? 0,
        isInfinite: _isInfinite,
        validity: _validity,
      );

      if (widget.vaccine != null && widget.vaccine!.id != null) {
        // Update existing vaccine
        await ApiService.updateVaccine(widget.vaccine!.id!, vaccine);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vaccine updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Create new vaccine
        await ApiService.createVaccine(vaccine);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vaccine created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vaccine != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Vaccine' : 'Add Vaccine'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[600]!,
              Colors.green[400]!,
              Colors.white,
            ],
            stops: const [0.0, 0.1, 0.1],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vaccine Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          
                          // Vaccine Name
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Vaccine Name *',
                              hintText: 'Enter vaccine name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.vaccines),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter vaccine name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Age Range
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _minAgeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Min Age *',
                                    hintText: '0',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.child_care),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 0) {
                                      return 'Invalid age';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _maxAgeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Max Age *',
                                    hintText: '100',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.elderly),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 0) {
                                      return 'Invalid age';
                                    }
                                    final minAge = int.tryParse(_minAgeController.text);
                                    if (minAge != null && age < minAge) {
                                      return 'Must be >= min age';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Checkboxes
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('Infinite Validity'),
                                  subtitle: const Text('No expiration date'),
                                  value: _isInfinite,
                                  onChanged: (value) {
                                    setState(() {
                                      _isInfinite = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                          
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('Valid'),
                                  subtitle: const Text('Vaccine is currently valid'),
                                  value: _validity,
                                  onChanged: (value) {
                                    setState(() {
                                      _validity = value ?? true;
                                    });
                                  },
                                  activeColor: Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Save Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveVaccine,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Vaccine' : 'Create Vaccine',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
