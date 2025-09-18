import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/health_data_service.dart';

class ClinicDataEntryScreen extends StatefulWidget {
  final String userType;

  const ClinicDataEntryScreen({super.key, required this.userType});

  @override
  State<ClinicDataEntryScreen> createState() => _ClinicDataEntryScreenState();
}

class _ClinicDataEntryScreenState extends State<ClinicDataEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _medicinesController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'O+';
  String _visitType = 'OPD';
  DateTime _visitDate = DateTime.now();
  bool _isEmergency = false;
  bool _requiresFollowup = false;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _visitTypes = ['OPD', 'Emergency', 'Follow-up', 'Routine Checkup', 'Vaccination'];

  @override
  void dispose() {
    _patientIdController.dispose();
    _patientNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _medicinesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Data Entry'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _savePatientData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Patient Registration & Treatment Record',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Date: ${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
                          style: TextStyle(
                            color: Colors.blue.shade100,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Patient Information Section
                _buildSectionCard(
                  title: 'Patient Information',
                  icon: Icons.person,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _patientIdController,
                            decoration: const InputDecoration(
                              labelText: 'Patient ID',
                              prefixIcon: Icon(Icons.badge),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Patient ID is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _visitType,
                            decoration: const InputDecoration(
                              labelText: 'Visit Type',
                              prefixIcon: Icon(Icons.medical_services),
                            ),
                            items: _visitTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _visitType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _patientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Patient name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              prefixIcon: Icon(Icons.cake),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Age is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.wc),
                            ),
                            items: _genderOptions.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedBloodGroup,
                            decoration: const InputDecoration(
                              labelText: 'Blood Group',
                              prefixIcon: Icon(Icons.bloodtype),
                            ),
                            items: _bloodGroups.map((group) {
                              return DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBloodGroup = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),

                // Medical Information Section
                _buildSectionCard(
                  title: 'Medical Information',
                  icon: Icons.medical_information,
                  children: [
                    TextFormField(
                      controller: _symptomsController,
                      decoration: const InputDecoration(
                        labelText: 'Symptoms',
                        prefixIcon: Icon(Icons.sick),
                        hintText: 'Describe the patient\'s symptoms...',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Symptoms are required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _diagnosisController,
                      decoration: const InputDecoration(
                        labelText: 'Diagnosis',
                        prefixIcon: Icon(Icons.local_hospital),
                        hintText: 'Medical diagnosis...',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Diagnosis is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _treatmentController,
                      decoration: const InputDecoration(
                        labelText: 'Treatment Given',
                        prefixIcon: Icon(Icons.healing),
                        hintText: 'Treatment provided...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _medicinesController,
                      decoration: const InputDecoration(
                        labelText: 'Medicines Prescribed',
                        prefixIcon: Icon(Icons.medication),
                        hintText: 'List medicines with dosage...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),

                // Additional Information Section
                _buildSectionCard(
                  title: 'Additional Information',
                  icon: Icons.info,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              'Emergency Case',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: _isEmergency,
                            onChanged: (value) {
                              setState(() {
                                _isEmergency = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              'Requires Follow-up',
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: _requiresFollowup,
                            onChanged: (value) {
                              setState(() {
                                _requiresFollowup = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Additional Notes',
                        prefixIcon: Icon(Icons.note),
                        hintText: 'Any additional observations or notes...',
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePatientData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Patient Record',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _savePatientData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final patientData = {
        'patientId': _patientIdController.text,
        'patientName': _patientNameController.text,
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
        'bloodGroup': _selectedBloodGroup,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'visitType': _visitType,
        'visitDate': _visitDate.toIso8601String(),
        'symptoms': _symptomsController.text,
        'diagnosis': _diagnosisController.text,
        'treatment': _treatmentController.text,
        'medicines': _medicinesController.text,
        'notes': _notesController.text,
        'isEmergency': _isEmergency,
        'requiresFollowup': _requiresFollowup,
        'enteredBy': widget.userType,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save to health data service
      await HealthDataService.saveClinicData(patientData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient record saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form or navigate back
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving patient record: $e'),
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

  void _clearForm() {
    _patientIdController.clear();
    _patientNameController.clear();
    _ageController.clear();
    _phoneController.clear();
    _addressController.clear();
    _symptomsController.clear();
    _diagnosisController.clear();
    _treatmentController.clear();
    _medicinesController.clear();
    _notesController.clear();
    
    setState(() {
      _selectedGender = 'Male';
      _selectedBloodGroup = 'O+';
      _visitType = 'OPD';
      _visitDate = DateTime.now();
      _isEmergency = false;
      _requiresFollowup = false;
    });
  }
}
