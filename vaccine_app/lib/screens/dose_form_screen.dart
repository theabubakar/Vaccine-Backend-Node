import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dose.dart';
import '../models/vaccine.dart';
import '../services/api_service.dart';

class DoseFormScreen extends StatefulWidget {
  final Dose? dose;
  final Vaccine? vaccine;

  const DoseFormScreen({super.key, this.dose, this.vaccine});

  @override
  State<DoseFormScreen> createState() => _DoseFormScreenState();
}

class _DoseFormScreenState extends State<DoseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();
  final _minGapController = TextEditingController();
  final _vaccineIdController = TextEditingController();
  
  List<Vaccine> vaccines = [];
  bool _isLoading = false;
  bool _isLoadingVaccines = true;

  @override
  void initState() {
    super.initState();
    _loadVaccines();
    if (widget.dose != null) {
      _nameController.text = widget.dose!.name ?? '';
      _minAgeController.text = widget.dose!.minAge.toString();
      _maxAgeController.text = widget.dose!.maxAge.toString();
      _minGapController.text = widget.dose!.minGap.toString();
      _vaccineIdController.text = widget.dose!.vaccineID is Map ? widget.dose!.vaccineID['_id'] : widget.dose!.vaccineID.toString();
    } else if (widget.vaccine != null) {
      // Pre-fill vaccine selection when creating a new dose for a specific vaccine
      _vaccineIdController.text = widget.vaccine!.id ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    _minGapController.dispose();
    _vaccineIdController.dispose();
    super.dispose();
  }

  Future<void> _loadVaccines() async {
    try {
      final loadedVaccines = await ApiService.getVaccines();
      setState(() {
        vaccines = loadedVaccines;
        _isLoadingVaccines = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVaccines = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading vaccines: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveDose() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dose = Dose(
        name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        minAge: int.tryParse(_minAgeController.text) ?? 0,
        maxAge: int.tryParse(_maxAgeController.text) ?? 0,
        minGap: int.tryParse(_minGapController.text) ?? 0,
        vaccineID: _vaccineIdController.text.trim().isEmpty ? null : _vaccineIdController.text.trim(),
      );

      if (widget.dose != null && widget.dose!.id != null) {
        // Update existing dose
        await ApiService.updateDose(widget.dose!.id!, dose);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dose updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Create new dose
        await ApiService.createDose(dose);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dose created successfully'),
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
    final isEditing = widget.dose != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Dose' : 'Add Dose'),
        backgroundColor: Colors.orange[600],
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
              Colors.orange[600]!,
              Colors.orange[400]!,
              Colors.white,
            ],
            stops: const [0.0, 0.1, 0.1],
          ),
        ),
        child: SafeArea(
          child: _isLoadingVaccines
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                  'Dose Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Dose Name
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Dose Name *',
                                    hintText: 'Enter dose name (e.g., First Dose, Booster)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.medication),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter dose name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // Vaccine ID Dropdown
                                DropdownButtonFormField<String>(
                                  initialValue: _vaccineIdController.text.isNotEmpty 
                                      ? _vaccineIdController.text 
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: widget.vaccine != null ? 'Vaccine (Pre-selected)' : 'Vaccine (Optional)',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.vaccines),
                                  ),
                                  items: vaccines.map((vaccine) {
                                    return DropdownMenuItem<String>(
                                      value: vaccine.id,
                                      child: Text('${vaccine.vaccineID} - ${vaccine.name}'),
                                    );
                                  }).toList(),
                                  onChanged: widget.vaccine != null ? null : (value) {
                                    setState(() {
                                      _vaccineIdController.text = value ?? '';
                                    });
                                  },
                                  validator: (value) {
                                    // Vaccine is now optional, no validation needed
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
                                const SizedBox(height: 16),
                                
                                // Min Gap
                                TextFormField(
                                  controller: _minGapController,
                                  decoration: const InputDecoration(
                                    labelText: 'Minimum Gap (Days) *',
                                    hintText: 'Enter minimum gap in days',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.schedule),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter minimum gap';
                                    }
                                    final gap = int.tryParse(value);
                                    if (gap == null || gap < 0) {
                                      return 'Invalid gap value';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Save Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveDose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
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
                                  isEditing ? 'Update Dose' : 'Create Dose',
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
