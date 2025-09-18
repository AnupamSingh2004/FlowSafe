import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/health_data_service.dart';

class AshaWorkerDataScreen extends StatefulWidget {
  final String userType;

  const AshaWorkerDataScreen({super.key, required this.userType});

  @override
  State<AshaWorkerDataScreen> createState() => _AshaWorkerDataScreenState();
}

class _AshaWorkerDataScreenState extends State<AshaWorkerDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyIdController = TextEditingController();
  final _headOfFamilyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _observationsController = TextEditingController();
  final _actionTakenController = TextEditingController();
  final _remarksController = TextEditingController();

  String _visitType = 'Routine Home Visit';
  String _selectedArea = 'Urban';
  DateTime _visitDate = DateTime.now();
  bool _pregnantWomen = false;
  bool _newborn = false;
  bool _elderlyIssues = false;
  bool _chronicDiseases = false;
  bool _immunizationDue = false;
  bool _nutritionConcerns = false;
  bool _isLoading = false;

  final List<String> _visitTypes = [
    'Routine Home Visit',
    'Maternal Health Visit',
    'Child Health Visit',
    'Immunization Visit',
    'Follow-up Visit',
    'Emergency Visit',
    'Health Education Session',
  ];

  final List<String> _areaTypes = ['Urban', 'Rural', 'Semi-Urban'];

  int _familyMembers = 1;
  int _childrenUnder5 = 0;
  int _pregnantWomenCount = 0;
  int _elderlyMembers = 0;

  @override
  void dispose() {
    _familyIdController.dispose();
    _headOfFamilyController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _observationsController.dispose();
    _actionTakenController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHA Worker Data Collection'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveASHAData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
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
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.personal_injury,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Community Health Visit Record',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'ASHA Worker: ${widget.userType}',
                          style: TextStyle(
                            color: Colors.green.shade100,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Visit Information Section
                _buildSectionCard(
                  title: 'Visit Information',
                  icon: Icons.event,
                  children: [
                    Row(
                      children: [
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedArea,
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
                                _selectedArea = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Visit Date: ${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _visitDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _visitDate = date;
                                });
                              }
                            },
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Family Information Section
                _buildSectionCard(
                  title: 'Family Information',
                  icon: Icons.family_restroom,
                  children: [
                    TextFormField(
                      controller: _familyIdController,
                      decoration: const InputDecoration(
                        labelText: 'Family ID',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Family ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _headOfFamilyController,
                      decoration: const InputDecoration(
                        labelText: 'Head of Family',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Head of family name is required';
                        }
                        return null;
                      },
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
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Total Members',
                              prefixIcon: const Icon(Icons.groups),
                              counterText: '',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _familyMembers = int.parse(value);
                                });
                              }
                            },
                            controller: TextEditingController(text: _familyMembers.toString()),
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
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Family Composition Section
                _buildSectionCard(
                  title: 'Family Composition',
                  icon: Icons.groups,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Children (<5 years)',
                            _childrenUnder5,
                            (value) => setState(() => _childrenUnder5 = value),
                            Icons.child_care,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCounterField(
                            'Pregnant Women',
                            _pregnantWomenCount,
                            (value) => setState(() => _pregnantWomenCount = value),
                            Icons.pregnant_woman,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCounterField(
                      'Elderly Members (>60 years)',
                      _elderlyMembers,
                      (value) => setState(() => _elderlyMembers = value),
                      Icons.elderly,
                    ),
                  ],
                ),

                // Health Concerns Section
                _buildSectionCard(
                  title: 'Health Concerns Identified',
                  icon: Icons.health_and_safety,
                  children: [
                    _buildCheckboxTile(
                      'Pregnant Women Issues',
                      _pregnantWomen,
                      (value) => setState(() => _pregnantWomen = value ?? false),
                      Icons.pregnant_woman,
                    ),
                    _buildCheckboxTile(
                      'Newborn Care Issues',
                      _newborn,
                      (value) => setState(() => _newborn = value ?? false),
                      Icons.baby_changing_station,
                    ),
                    _buildCheckboxTile(
                      'Elderly Health Issues',
                      _elderlyIssues,
                      (value) => setState(() => _elderlyIssues = value ?? false),
                      Icons.elderly_woman,
                    ),
                    _buildCheckboxTile(
                      'Chronic Diseases',
                      _chronicDiseases,
                      (value) => setState(() => _chronicDiseases = value ?? false),
                      Icons.sick,
                    ),
                    _buildCheckboxTile(
                      'Immunization Due',
                      _immunizationDue,
                      (value) => setState(() => _immunizationDue = value ?? false),
                      Icons.vaccines,
                    ),
                    _buildCheckboxTile(
                      'Nutrition Concerns',
                      _nutritionConcerns,
                      (value) => setState(() => _nutritionConcerns = value ?? false),
                      Icons.restaurant,
                    ),
                  ],
                ),

                // Observations and Actions Section
                _buildSectionCard(
                  title: 'Observations & Actions',
                  icon: Icons.notes,
                  children: [
                    TextFormField(
                      controller: _observationsController,
                      decoration: const InputDecoration(
                        labelText: 'Observations',
                        prefixIcon: Icon(Icons.visibility),
                        hintText: 'Detailed observations during the visit...',
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Observations are required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _actionTakenController,
                      decoration: const InputDecoration(
                        labelText: 'Action Taken',
                        prefixIcon: Icon(Icons.healing),
                        hintText: 'Actions taken during the visit...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _remarksController,
                      decoration: const InputDecoration(
                        labelText: 'Remarks & Follow-up Required',
                        prefixIcon: Icon(Icons.comment),
                        hintText: 'Additional remarks and follow-up requirements...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveASHAData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save ASHA Visit Record',
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
                Icon(icon, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
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
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green.shade700, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
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
                    color: Colors.green.shade700,
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
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onChanged(value + 1),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.green.shade700,
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
          Icon(icon, color: Colors.green.shade700, size: 18),
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
      activeColor: Colors.green.shade700,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  Future<void> _saveASHAData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final ashaData = {
        'familyId': _familyIdController.text,
        'headOfFamily': _headOfFamilyController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'visitType': _visitType,
        'areaType': _selectedArea,
        'visitDate': _visitDate.toIso8601String(),
        'familyMembers': _familyMembers,
        'childrenUnder5': _childrenUnder5,
        'pregnantWomenCount': _pregnantWomenCount,
        'elderlyMembers': _elderlyMembers,
        'healthConcerns': {
          'pregnantWomen': _pregnantWomen,
          'newborn': _newborn,
          'elderlyIssues': _elderlyIssues,
          'chronicDiseases': _chronicDiseases,
          'immunizationDue': _immunizationDue,
          'nutritionConcerns': _nutritionConcerns,
        },
        'observations': _observationsController.text,
        'actionTaken': _actionTakenController.text,
        'remarks': _remarksController.text,
        'ashaWorker': widget.userType,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save to health data service
      await HealthDataService.saveASHAData(ashaData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ASHA visit record saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving ASHA data: $e'),
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
    _familyIdController.clear();
    _headOfFamilyController.clear();
    _phoneController.clear();
    _addressController.clear();
    _observationsController.clear();
    _actionTakenController.clear();
    _remarksController.clear();
    
    setState(() {
      _visitType = 'Routine Home Visit';
      _selectedArea = 'Urban';
      _visitDate = DateTime.now();
      _pregnantWomen = false;
      _newborn = false;
      _elderlyIssues = false;
      _chronicDiseases = false;
      _immunizationDue = false;
      _nutritionConcerns = false;
      _familyMembers = 1;
      _childrenUnder5 = 0;
      _pregnantWomenCount = 0;
      _elderlyMembers = 0;
    });
  }
}
