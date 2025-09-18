import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/health_data_service.dart';

class EmergencyReportScreen extends StatefulWidget {
  final String userType;

  const EmergencyReportScreen({super.key, required this.userType});

  @override
  State<EmergencyReportScreen> createState() => _EmergencyReportScreenState();
}

class _EmergencyReportScreenState extends State<EmergencyReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _affectedPersonsController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _immediateActionsController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  String _emergencyType = 'Disease Outbreak';
  String _severity = 'HIGH';
  String _status = 'ACTIVE';
  DateTime _incidentDate = DateTime.now();
  TimeOfDay _incidentTime = TimeOfDay.now();
  bool _authoritiesNotified = false;
  bool _mediaAttentionRequired = false;
  bool _resourcesNeeded = false;
  bool _evacuationRequired = false;
  bool _medicalAssistanceNeeded = true;
  bool _isLoading = false;

  final List<String> _emergencyTypes = [
    'Disease Outbreak',
    'Food Poisoning',
    'Water Contamination',
    'Air Pollution',
    'Chemical Spill',
    'Medical Emergency',
    'Public Health Crisis',
    'Mass Casualty Incident',
    'Environmental Hazard',
    'Infectious Disease Spread',
    'Mental Health Crisis',
    'Drug Overdose Cluster',
  ];

  final List<String> _severityLevels = ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'];
  final List<String> _statusOptions = ['ACTIVE', 'UNDER_CONTROL', 'RESOLVED'];

  int _estimatedAffected = 0;
  int _confirmedCases = 0;
  int _deaths = 0;
  int _hospitalized = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _affectedPersonsController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _immediateActionsController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Health Report'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isLoading ? null : _submitEmergencyReport,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade50,
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
                // Emergency Alert Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emergency,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '🚨 EMERGENCY HEALTH REPORT 🚨',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This report will be sent immediately to health authorities',
                        style: TextStyle(
                          color: Colors.red.shade100,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Basic Information Section
                _buildSectionCard(
                  title: 'Emergency Information',
                  icon: Icons.info,
                  color: Colors.red,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Title *',
                        prefixIcon: Icon(Icons.title),
                        hintText: 'Brief title describing the emergency',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Emergency title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: _emergencyType,
                            decoration: const InputDecoration(
                              labelText: 'Emergency Type *',
                              prefixIcon: Icon(Icons.warning, size: 18),
                              labelStyle: TextStyle(fontSize: 11),
                            ),
                            items: _emergencyTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: const TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _emergencyType = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: _severity,
                            decoration: const InputDecoration(
                              labelText: 'Severity *',
                              prefixIcon: Icon(Icons.priority_high, size: 18),
                              labelStyle: TextStyle(fontSize: 11),
                            ),
                            items: _severityLevels.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(
                                  level,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getSeverityColor(level),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _severity = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location/Address *',
                        prefixIcon: Icon(Icons.location_on),
                        hintText: 'Exact location of the emergency',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Location is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Date and Time Section
                _buildSectionCard(
                  title: 'Incident Date & Time',
                  icon: Icons.schedule,
                  color: Colors.red,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Date: ${_incidentDate.day}/${_incidentDate.month}/${_incidentDate.year}',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _incidentDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 7)),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _incidentDate = date;
                                    });
                                  }
                                },
                                child: const Text('Change'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Time: ${_incidentTime.format(context)}',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: _incidentTime,
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _incidentTime = time;
                                    });
                                  }
                                },
                                child: const Text('Change'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Impact Assessment Section
                _buildSectionCard(
                  title: 'Impact Assessment',
                  icon: Icons.people,
                  color: Colors.red,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Estimated\nAffected',
                            _estimatedAffected,
                            (value) => setState(() => _estimatedAffected = value),
                            Icons.people_outline,
                            Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCounterField(
                            'Confirmed\nCases',
                            _confirmedCases,
                            (value) => setState(() => _confirmedCases = value),
                            Icons.coronavirus,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Deaths',
                            _deaths,
                            (value) => setState(() => _deaths = value),
                            Icons.dangerous,
                            Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCounterField(
                            'Hospitalized',
                            _hospitalized,
                            (value) => setState(() => _hospitalized = value),
                            Icons.local_hospital,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Description Section
                _buildSectionCard(
                  title: 'Detailed Description',
                  icon: Icons.description,
                  color: Colors.red,
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Description *',
                        prefixIcon: Icon(Icons.description),
                        hintText: 'Provide detailed description of the emergency situation...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Detailed description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _immediateActionsController,
                      decoration: const InputDecoration(
                        labelText: 'Immediate Actions Taken',
                        prefixIcon: Icon(Icons.flash_on),
                        hintText: 'Describe actions taken immediately after the incident...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),

                // Contact Information Section
                _buildSectionCard(
                  title: 'Contact Information',
                  icon: Icons.contact_phone,
                  color: Colors.red,
                  children: [
                    TextFormField(
                      controller: _contactPersonController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Person *',
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Name of person reporting',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Contact person name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Phone *',
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Emergency contact number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Emergency contact number is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Status and Requirements Section
                _buildSectionCard(
                  title: 'Status & Requirements',
                  icon: Icons.check_circle,
                  color: Colors.red,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Current Status',
                        prefixIcon: Icon(Icons.flag),
                      ),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.replaceAll('_', ' '),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Emergency Requirements:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCheckboxTile(
                      'Authorities Already Notified',
                      _authoritiesNotified,
                      (value) => setState(() => _authoritiesNotified = value ?? false),
                      Icons.shield,
                      Colors.red,
                    ),
                    _buildCheckboxTile(
                      'Medical Assistance Needed',
                      _medicalAssistanceNeeded,
                      (value) => setState(() => _medicalAssistanceNeeded = value ?? false),
                      Icons.medical_services,
                      Colors.red,
                    ),
                    _buildCheckboxTile(
                      'Resources/Supplies Needed',
                      _resourcesNeeded,
                      (value) => setState(() => _resourcesNeeded = value ?? false),
                      Icons.inventory,
                      Colors.red,
                    ),
                    _buildCheckboxTile(
                      'Evacuation Required',
                      _evacuationRequired,
                      (value) => setState(() => _evacuationRequired = value ?? false),
                      Icons.exit_to_app,
                      Colors.red,
                    ),
                    _buildCheckboxTile(
                      'Media Attention Required',
                      _mediaAttentionRequired,
                      (value) => setState(() => _mediaAttentionRequired = value ?? false),
                      Icons.campaign,
                      Colors.red,
                    ),
                  ],
                ),

                // Additional Information Section
                _buildSectionCard(
                  title: 'Additional Information',
                  icon: Icons.add_circle,
                  color: Colors.red,
                  children: [
                    TextFormField(
                      controller: _additionalInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Additional Notes',
                        prefixIcon: Icon(Icons.note_add),
                        hintText: 'Any additional relevant information...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Warning Notice
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This emergency report will be sent immediately to health authorities and emergency response teams.',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitEmergencyReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'SUBMIT EMERGENCY REPORT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
    required MaterialColor color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.shade700,
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

  Widget _buildCounterField(
    String label,
    int value,
    Function(int) onChanged,
    IconData icon,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.shade300),
        borderRadius: BorderRadius.circular(8),
        color: color.shade50,
      ),
      child: Column(
        children: [
          Icon(icon, color: color.shade700, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color.shade700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: value > 0 ? () => onChanged(value - 1) : null,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: color.shade700,
                    size: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.shade700,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onChanged(value + 1),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: color.shade700,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    Function(bool?) onChanged,
    IconData icon,
    MaterialColor color,
  ) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, color: color.shade700, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: color.shade700,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'LOW':
        return Colors.green;
      case 'MEDIUM':
        return Colors.orange;
      case 'HIGH':
        return Colors.red;
      case 'CRITICAL':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  Future<void> _submitEmergencyReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirm Emergency Report'),
          ],
        ),
        content: const Text(
          'This will immediately alert health authorities and emergency response teams. Are you sure you want to submit this emergency report?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Submit Emergency Report'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final emergencyData = {
        'reportType': 'EMERGENCY',
        'title': _titleController.text,
        'emergencyType': _emergencyType,
        'severity': _severity,
        'status': _status,
        'location': _locationController.text,
        'incidentDate': _incidentDate.toIso8601String(),
        'incidentTime': '${_incidentTime.hour}:${_incidentTime.minute}',
        'description': _descriptionController.text,
        'impact': {
          'estimatedAffected': _estimatedAffected,
          'confirmedCases': _confirmedCases,
          'deaths': _deaths,
          'hospitalized': _hospitalized,
        },
        'contact': {
          'contactPerson': _contactPersonController.text,
          'contactPhone': _contactPhoneController.text,
        },
        'requirements': {
          'authoritiesNotified': _authoritiesNotified,
          'medicalAssistanceNeeded': _medicalAssistanceNeeded,
          'resourcesNeeded': _resourcesNeeded,
          'evacuationRequired': _evacuationRequired,
          'mediaAttentionRequired': _mediaAttentionRequired,
        },
        'immediateActions': _immediateActionsController.text,
        'additionalInfo': _additionalInfoController.text,
        'reportedBy': widget.userType,
        'timestamp': DateTime.now().toIso8601String(),
        'priority': 'EMERGENCY',
        'alertLevel': 'CRITICAL',
      };

      // Save emergency report
      await HealthDataService.saveEmergencyReport(emergencyData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Emergency report submitted successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Report Submitted'),
              ],
            ),
            content: const Text(
              'Your emergency report has been submitted successfully and authorities have been notified immediately. Emergency response teams will be dispatched if required.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error submitting emergency report: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
}
