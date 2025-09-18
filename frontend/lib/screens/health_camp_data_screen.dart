import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/health_data_service.dart';

class HealthCampDataScreen extends StatefulWidget {
  final String userType;

  const HealthCampDataScreen({super.key, required this.userType});

  @override
  State<HealthCampDataScreen> createState() => _HealthCampDataScreenState();
}

class _HealthCampDataScreenState extends State<HealthCampDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _campIdController = TextEditingController();
  final _campNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();
  final _doctorsController = TextEditingController();
  final _volunteersController = TextEditingController();
  final _servicesProvidedController = TextEditingController();
  final _medicinesDistributedController = TextEditingController();
  final _remarksController = TextEditingController();

  String _campType = 'General Health Camp';
  String _areaType = 'Urban';
  DateTime _campDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _freeConsultation = true;
  bool _freeMedicines = true;
  bool _healthEducation = false;
  bool _screening = false;
  bool _vaccination = false;
  bool _followUpProvided = false;
  bool _isLoading = false;

  final List<String> _campTypes = [
    'General Health Camp',
    'Eye Care Camp',
    'Dental Camp',
    'Maternal Health Camp',
    'Child Health Camp',
    'Diabetes Screening Camp',
    'Hypertension Screening Camp',
    'Cancer Screening Camp',
    'Mental Health Camp',
    'Nutrition & Wellness Camp',
    'Vaccination Camp',
    'Blood Donation Camp',
  ];

  final List<String> _areaTypes = ['Urban', 'Rural', 'Semi-Urban', 'Tribal'];

  // Statistics
  int _totalRegistrations = 0;
  int _malePatients = 0;
  int _femalePatients = 0;
  int _childPatients = 0;
  int _elderlyPatients = 0;
  int _consultationsGiven = 0;
  int _referralsMade = 0;
  int _medicinesDistributed = 0;
  int _vaccinationsGiven = 0;

  @override
  void dispose() {
    _campIdController.dispose();
    _campNameController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _doctorsController.dispose();
    _volunteersController.dispose();
    _servicesProvidedController.dispose();
    _medicinesDistributedController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Camp Data'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveHealthCampData,
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
                // Header Card
                Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Health Camp Data Collection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Organizer: ${widget.userType}',
                          style: TextStyle(
                            color: Colors.red.shade100,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Camp Information Section
                _buildSectionCard(
                  title: 'Camp Information',
                  icon: Icons.event,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _campIdController,
                            decoration: const InputDecoration(
                              labelText: 'Camp ID',
                              prefixIcon: Icon(Icons.tag),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Camp ID is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _campType,
                            decoration: const InputDecoration(
                              labelText: 'Camp Type',
                              prefixIcon: Icon(Icons.medical_services),
                            ),
                            items: _campTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type, 
                                  style: const TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _campType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _campNameController,
                      decoration: const InputDecoration(
                        labelText: 'Camp Name',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Camp name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location/Venue',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Location is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _areaType,
                            decoration: const InputDecoration(
                              labelText: 'Area Type',
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            items: _areaTypes.map((area) {
                              return DropdownMenuItem(
                                value: area,
                                child: Text(area),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _areaType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _organizerController,
                      decoration: const InputDecoration(
                        labelText: 'Organizing Institution',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Organizer information is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Date and Time Section
                _buildSectionCard(
                  title: 'Date & Time',
                  icon: Icons.schedule,
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
                                'Camp Date: ${_campDate.day}/${_campDate.month}/${_campDate.year}',
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
                                    initialDate: _campDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now().add(const Duration(days: 30)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _campDate = date;
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
                              Expanded(
                                child: ListTile(
                                  leading: Icon(Icons.play_arrow, color: Colors.red.shade700),
                                  title: const Text('Start Time'),
                                  subtitle: Text(_startTime.format(context)),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _startTime,
                                    );
                                    if (time != null) {
                                      setState(() {
                                        _startTime = time;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  leading: Icon(Icons.stop, color: Colors.red.shade700),
                                  title: const Text('End Time'),
                                  subtitle: Text(_endTime.format(context)),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _endTime,
                                    );
                                    if (time != null) {
                                      setState(() {
                                        _endTime = time;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Staff Information Section
                _buildSectionCard(
                  title: 'Staff Information',
                  icon: Icons.people,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _doctorsController,
                            decoration: const InputDecoration(
                              labelText: 'Number of Doctors',
                              prefixIcon: Icon(Icons.local_hospital),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _volunteersController,
                            decoration: const InputDecoration(
                              labelText: 'Number of Volunteers',
                              prefixIcon: Icon(Icons.volunteer_activism),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Services Provided Section
                _buildSectionCard(
                  title: 'Services Provided',
                  icon: Icons.medical_services,
                  children: [
                    _buildCheckboxTile(
                      'Free Consultation',
                      _freeConsultation,
                      (value) => setState(() => _freeConsultation = value ?? false),
                      Icons.assignment,
                    ),
                    _buildCheckboxTile(
                      'Free Medicines',
                      _freeMedicines,
                      (value) => setState(() => _freeMedicines = value ?? false),
                      Icons.medication,
                    ),
                    _buildCheckboxTile(
                      'Health Education Sessions',
                      _healthEducation,
                      (value) => setState(() => _healthEducation = value ?? false),
                      Icons.school,
                    ),
                    _buildCheckboxTile(
                      'Health Screening',
                      _screening,
                      (value) => setState(() => _screening = value ?? false),
                      Icons.health_and_safety,
                    ),
                    _buildCheckboxTile(
                      'Vaccination',
                      _vaccination,
                      (value) => setState(() => _vaccination = value ?? false),
                      Icons.vaccines,
                    ),
                    _buildCheckboxTile(
                      'Follow-up Provided',
                      _followUpProvided,
                      (value) => setState(() => _followUpProvided = value ?? false),
                      Icons.follow_the_signs,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _servicesProvidedController,
                      decoration: const InputDecoration(
                        labelText: 'Other Services Provided',
                        prefixIcon: Icon(Icons.list),
                        hintText: 'Additional services not listed above...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),

                // Patient Statistics Section
                _buildSectionCard(
                  title: 'Patient Statistics',
                  icon: Icons.analytics,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Total\nRegistrations',
                            _totalRegistrations,
                            (value) => setState(() => _totalRegistrations = value),
                            Icons.app_registration,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCounterField(
                            'Consultations\nGiven',
                            _consultationsGiven,
                            (value) => setState(() => _consultationsGiven = value),
                            Icons.medical_services,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Patient Demographics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Male\nPatients',
                            _malePatients,
                            (value) => setState(() => _malePatients = value),
                            Icons.man,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCounterField(
                            'Female\nPatients',
                            _femalePatients,
                            (value) => setState(() => _femalePatients = value),
                            Icons.woman,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCounterField(
                            'Child\nPatients',
                            _childPatients,
                            (value) => setState(() => _childPatients = value),
                            Icons.child_care,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCounterField(
                            'Elderly\nPatients',
                            _elderlyPatients,
                            (value) => setState(() => _elderlyPatients = value),
                            Icons.elderly,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Referrals\nMade',
                            _referralsMade,
                            (value) => setState(() => _referralsMade = value),
                            Icons.send,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCounterField(
                            'Medicines\nDistributed',
                            _medicinesDistributed,
                            (value) => setState(() => _medicinesDistributed = value),
                            Icons.medication,
                          ),
                        ),
                      ],
                    ),
                    if (_vaccination)
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildCounterField(
                            'Vaccinations Given',
                            _vaccinationsGiven,
                            (value) => setState(() => _vaccinationsGiven = value),
                            Icons.vaccines,
                          ),
                        ],
                      ),
                  ],
                ),

                // Additional Information Section
                _buildSectionCard(
                  title: 'Additional Information',
                  icon: Icons.notes,
                  children: [
                    TextFormField(
                      controller: _medicinesDistributedController,
                      decoration: const InputDecoration(
                        labelText: 'Medicines/Supplies Distributed',
                        prefixIcon: Icon(Icons.inventory_2),
                        hintText: 'List of medicines and supplies distributed...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _remarksController,
                      decoration: const InputDecoration(
                        labelText: 'Remarks & Observations',
                        prefixIcon: Icon(Icons.comment),
                        hintText: 'Additional remarks and observations...',
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
                    onPressed: _isLoading ? null : _saveHealthCampData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Health Camp Data',
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
                Icon(icon, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.red.shade700, size: 18),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: value > 0 ? () => onChanged(value - 1) : null,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red.shade700,
                    size: 18,
                  ),
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              InkWell(
                onTap: () => onChanged(value + 1),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.red.shade700,
                    size: 18,
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
  ) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.red.shade700, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title, 
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red.shade700,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  Future<void> _saveHealthCampData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final campData = {
        'campId': _campIdController.text,
        'campName': _campNameController.text,
        'campType': _campType,
        'location': _locationController.text,
        'areaType': _areaType,
        'organizer': _organizerController.text,
        'campDate': _campDate.toIso8601String(),
        'startTime': '${_startTime.hour}:${_startTime.minute}',
        'endTime': '${_endTime.hour}:${_endTime.minute}',
        'staff': {
          'doctors': int.tryParse(_doctorsController.text) ?? 0,
          'volunteers': int.tryParse(_volunteersController.text) ?? 0,
        },
        'services': {
          'freeConsultation': _freeConsultation,
          'freeMedicines': _freeMedicines,
          'healthEducation': _healthEducation,
          'screening': _screening,
          'vaccination': _vaccination,
          'followUpProvided': _followUpProvided,
          'otherServices': _servicesProvidedController.text,
        },
        'statistics': {
          'totalRegistrations': _totalRegistrations,
          'consultationsGiven': _consultationsGiven,
          'malePatients': _malePatients,
          'femalePatients': _femalePatients,
          'childPatients': _childPatients,
          'elderlyPatients': _elderlyPatients,
          'referralsMade': _referralsMade,
          'medicinesDistributed': _medicinesDistributed,
          'vaccinationsGiven': _vaccinationsGiven,
        },
        'medicinesSupplies': _medicinesDistributedController.text,
        'remarks': _remarksController.text,
        'organizedBy': widget.userType,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save to health data service
      await HealthDataService.saveHealthCampData(campData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health camp data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving health camp data: $e'),
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
    _campIdController.clear();
    _campNameController.clear();
    _locationController.clear();
    _organizerController.clear();
    _doctorsController.clear();
    _volunteersController.clear();
    _servicesProvidedController.clear();
    _medicinesDistributedController.clear();
    _remarksController.clear();
    
    setState(() {
      _campType = 'General Health Camp';
      _areaType = 'Urban';
      _campDate = DateTime.now();
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
      _freeConsultation = true;
      _freeMedicines = true;
      _healthEducation = false;
      _screening = false;
      _vaccination = false;
      _followUpProvided = false;
      _totalRegistrations = 0;
      _malePatients = 0;
      _femalePatients = 0;
      _childPatients = 0;
      _elderlyPatients = 0;
      _consultationsGiven = 0;
      _referralsMade = 0;
      _medicinesDistributed = 0;
      _vaccinationsGiven = 0;
    });
  }
}
