import 'package:flutter/material.dart';
import '../models/vaccine.dart';
import '../models/dose.dart';
import '../services/api_service.dart';
import 'dose_form_screen.dart';

class VaccineDosesScreen extends StatefulWidget {
  final Vaccine vaccine;

  const VaccineDosesScreen({
    super.key,
    required this.vaccine,
  });

  @override
  State<VaccineDosesScreen> createState() => _VaccineDosesScreenState();
}

class _VaccineDosesScreenState extends State<VaccineDosesScreen> {
  List<Dose> doses = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadDoses();
  }

  Future<void> _loadDoses() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedDoses = await ApiService.getDosesByVaccineId(widget.vaccine.id!);
      setState(() {
        doses = loadedDoses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteDose(String doseId) async {
    try {
      await ApiService.deleteDose(doseId);
      await _loadDoses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dose deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting dose: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteDialog(Dose dose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Dose'),
          content: Text('Are you sure you want to delete "${dose.name ?? 'Unnamed Dose'}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (dose.id != null) {
                  _deleteDose(dose.id!);
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vaccine.name} - Doses'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDoses,
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
          child: Column(
            children: [
              // Vaccine Info Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vaccines, color: Colors.orange[600], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Vaccine Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Name: ${widget.vaccine.name}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text('ID: ${widget.vaccine.vaccineID}'),
                    const SizedBox(height: 4),
                    Text('Age Range: ${widget.vaccine.minAge}-${widget.vaccine.maxAge} years'),
                    const SizedBox(height: 4),
                    Text('Infinite Validity: ${widget.vaccine.isInfinite ? "Yes" : "No"}'),
                    const SizedBox(height: 4),
                    Text('Status: ${widget.vaccine.validity ? "Active" : "Inactive"}'),
                  ],
                ),
              ),
              
              // Doses List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error loading doses',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    error!,
                                    style: TextStyle(color: Colors.red[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadDoses,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : doses.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.medication_outlined,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No doses found',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add the first dose for this vaccine',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: doses.length,
                                  itemBuilder: (context, index) {
                                    final dose = doses[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(16),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.orange[100],
                                          child: Icon(
                                            Icons.medication,
                                            color: Colors.orange[600],
                                          ),
                                        ),
                                        title: Text(
                                          dose.name ?? 'Unnamed Dose',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text('Dose ID: ${dose.doseId ?? 'N/A'}'),
                                            Text('Age Range: ${dose.minAge}-${dose.maxAge} years'),
                                            Text('Min Gap: ${dose.minGap} days'),
                                            if (dose.createdAt != null)
                                              Text(
                                                'Created: ${dose.createdAt!.day}/${dose.createdAt!.month}/${dose.createdAt!.year}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                          ],
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => DoseFormScreen(
                                                    dose: dose,
                                                    vaccine: widget.vaccine,
                                                  ),
                                                ),
                                              ).then((_) => _loadDoses());
                                            } else if (value == 'delete') {
                                              _showDeleteDialog(dose);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) => [
                                            const PopupMenuItem<String>(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, color: Colors.blue),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Delete'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoseFormScreen(
                vaccine: widget.vaccine,
              ),
            ),
          ).then((_) => _loadDoses());
        },
        backgroundColor: Colors.orange[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
