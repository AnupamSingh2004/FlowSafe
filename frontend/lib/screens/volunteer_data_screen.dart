import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/health_data_service.dart';

class VolunteerDataScreen extends StatefulWidget {
  final String userType;

  const VolunteerDataScreen({super.key, required this.userType});

  @override
  State<VolunteerDataScreen> createState() => _VolunteerDataScreenState();
}

class _VolunteerDataScreenState extends State<VolunteerDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _activityTitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _participantsController = TextEditingController();
  final _outcomesController = TextEditingController();
  final _challengesController = TextEditingController();
  final _followUpController = TextEditingController();

  String _activityType = 'Awareness Campaign';
  String _targetGroup = 'General Public';
  String _volunteerOrganization = 'Local NGO';
  DateTime _activityDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _materialsDistributed = false;
  bool _dataCollected = false;
  bool _photosTaken = false;
  bool _followUpRequired = false;
  bool _isLoading = false;

  final List<String> _activityTypes = [
    'Awareness Campaign',
    'Health Education',
    'Community Survey',
    'Vaccination Drive Support',
    'Sanitation Drive',
    'Nutrition Program',
    'Mother & Child Health',
    'Disease Prevention',
    'Mental Health Awareness',
    'First Aid Training',
  ];

  final List<String> _targetGroups = [
    'General Public',
    'Women',
    'Children',
    'Elderly',
    'Pregnant Women',
    'Students',
    'Workers',
    'Rural Community',
    'Urban Slum',
    'Tribal Community',
  ];

  final List<String> _organizations = [
    'Local NGO',
    'Government Program',
    'Religious Organization',
    'Self Help Group',
    'Youth Organization',
    'Women\'s Group',
    'Community Organization',
    'Health Department',
  ];

  int _maleParticipants = 0;
  int _femaleParticipants = 0;
  int _childParticipants = 0;
  int _elderlyParticipants = 0;

  @override
  void dispose() {
    _activityTitleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _participantsController.dispose();
    _outcomesController.dispose();
    _challengesController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Activity Data'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveVolunteerData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
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
                      color: Colors.purple.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.volunteer_activism,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Community Volunteer Activity Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Volunteer: ${widget.userType}',
                          style: TextStyle(
                            color: Colors.purple.shade100,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Activity Information Section
                _buildSectionCard(
                  title: 'Activity Information',
                  icon: Icons.event,
                  children: [
                    TextFormField(
                      controller: _activityTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Activity Title',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Activity title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _activityType,
                            decoration: const InputDecoration(
                              labelText: 'Activity Type',
                              prefixIcon: Icon(Icons.category),
                            ),
                            items: _activityTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _activityType = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _targetGroup,
                            decoration: const InputDecoration(
                              labelText: 'Target Group',
                              prefixIcon: Icon(Icons.group),
                            ),
                            items: _targetGroups.map((group) {
                              return DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _targetGroup = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _volunteerOrganization,
                      decoration: const InputDecoration(
                        labelText: 'Organization/Group',
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: _organizations.map((org) {
                        return DropdownMenuItem(
                          value: org,
                          child: Text(org),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _volunteerOrganization = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
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
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.purple.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Date: ${_activityDate.day}/${_activityDate.month}/${_activityDate.year}',
                                style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _activityDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _activityDate = date;
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
                                  leading: Icon(Icons.play_arrow, color: Colors.purple.shade700),
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
                                  leading: Icon(Icons.stop, color: Colors.purple.shade700),
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

                // Participants Section
                _buildSectionCard(
                  title: 'Participants',
                  icon: Icons.groups,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Male',
                            _maleParticipants,
                            (value) => setState(() => _maleParticipants = value),
                            Icons.man,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCounterField(
                            'Female',
                            _femaleParticipants,
                            (value) => setState(() => _femaleParticipants = value),
                            Icons.woman,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Children',
                            _childParticipants,
                            (value) => setState(() => _childParticipants = value),
                            Icons.child_care,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCounterField(
                            'Elderly',
                            _elderlyParticipants,
                            (value) => setState(() => _elderlyParticipants = value),
                            Icons.elderly,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, color: Colors.purple.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Total: ${_maleParticipants + _femaleParticipants + _childParticipants + _elderlyParticipants}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Activity Details Section
                _buildSectionCard(
                  title: 'Activity Details',
                  icon: Icons.description,
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Activity Description',
                        prefixIcon: Icon(Icons.description),
                        hintText: 'Detailed description of the activity...',
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Activity description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _outcomesController,
                      decoration: const InputDecoration(
                        labelText: 'Outcomes & Impact',
                        prefixIcon: Icon(Icons.trending_up),
                        hintText: 'What was achieved, impact on community...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _challengesController,
                      decoration: const InputDecoration(
                        labelText: 'Challenges Faced',
                        prefixIcon: Icon(Icons.warning),
                        hintText: 'Any difficulties or obstacles encountered...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),

                // Activity Status Section
                _buildSectionCard(
                  title: 'Activity Status',
                  icon: Icons.check_circle,
                  children: [
                    _buildCheckboxTile(
                      'Materials Distributed',
                      _materialsDistributed,
                      (value) => setState(() => _materialsDistributed = value ?? false),
                      Icons.inventory,
                    ),
                    _buildCheckboxTile(
                      'Data Collected',
                      _dataCollected,
                      (value) => setState(() => _dataCollected = value ?? false),
                      Icons.data_usage,
                    ),
                    _buildCheckboxTile(
                      'Photos/Documentation',
                      _photosTaken,
                      (value) => setState(() => _photosTaken = value ?? false),
                      Icons.camera_alt,
                    ),
                    _buildCheckboxTile(
                      'Follow-up Required',
                      _followUpRequired,
                      (value) => setState(() => _followUpRequired = value ?? false),
                      Icons.follow_the_signs,
                    ),
                  ],
                ),

                // Follow-up Section (conditional)
                if (_followUpRequired)
                  _buildSectionCard(
                    title: 'Follow-up Actions',
                    icon: Icons.follow_the_signs,
                    children: [
                      TextFormField(
                        controller: _followUpController,
                        decoration: const InputDecoration(
                          labelText: 'Follow-up Actions Required',
                          prefixIcon: Icon(Icons.assignment),
                          hintText: 'Describe necessary follow-up actions...',
                        ),
                        maxLines: 3,
                        validator: _followUpRequired
                            ? (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Follow-up description is required';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveVolunteerData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Volunteer Activity Report',
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
                Icon(icon, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purple.shade700, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
                    color: Colors.purple.shade700,
                    size: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onChanged(value + 1),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.purple.shade700,
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
  ) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.purple.shade700, size: 18),
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
      activeColor: Colors.purple.shade700,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  Future<void> _saveVolunteerData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final volunteerData = {
        'activityTitle': _activityTitleController.text,
        'activityType': _activityType,
        'targetGroup': _targetGroup,
        'organization': _volunteerOrganization,
        'location': _locationController.text,
        'activityDate': _activityDate.toIso8601String(),
        'startTime': '${_startTime.hour}:${_startTime.minute}',
        'endTime': '${_endTime.hour}:${_endTime.minute}',
        'participants': {
          'male': _maleParticipants,
          'female': _femaleParticipants,
          'children': _childParticipants,
          'elderly': _elderlyParticipants,
          'total': _maleParticipants + _femaleParticipants + _childParticipants + _elderlyParticipants,
        },
        'description': _descriptionController.text,
        'outcomes': _outcomesController.text,
        'challenges': _challengesController.text,
        'status': {
          'materialsDistributed': _materialsDistributed,
          'dataCollected': _dataCollected,
          'photosTaken': _photosTaken,
          'followUpRequired': _followUpRequired,
        },
        'followUpActions': _followUpRequired ? _followUpController.text : '',
        'volunteer': widget.userType,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save to health data service
      await HealthDataService.saveVolunteerData(volunteerData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Volunteer activity report saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving volunteer data: $e'),
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
    _activityTitleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    _participantsController.clear();
    _outcomesController.clear();
    _challengesController.clear();
    _followUpController.clear();
    
    setState(() {
      _activityType = 'Awareness Campaign';
      _targetGroup = 'General Public';
      _volunteerOrganization = 'Local NGO';
      _activityDate = DateTime.now();
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
      _materialsDistributed = false;
      _dataCollected = false;
      _photosTaken = false;
      _followUpRequired = false;
      _maleParticipants = 0;
      _femaleParticipants = 0;
      _childParticipants = 0;
      _elderlyParticipants = 0;
    });
  }
}
