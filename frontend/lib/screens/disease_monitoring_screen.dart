import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class DiseaseMonitoringScreen extends StatefulWidget {
  final String userType;
  
  const DiseaseMonitoringScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<DiseaseMonitoringScreen> createState() => _DiseaseMonitoringScreenState();
}

class _DiseaseMonitoringScreenState extends State<DiseaseMonitoringScreen> {
  bool _isLoading = false;
  Position? _currentPosition;
  String _currentLocation = 'Loading...';
  
  // Form controllers
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  
  String _selectedDisease = 'Diarrhea';
  String _selectedSeverity = 'Mild';
  String _selectedGender = 'Male';
  List<String> _selectedSymptoms = [];
  String _waterSourceUsed = 'Borewell';
  DateTime _onsetDate = DateTime.now();
  bool _hospitalizationRequired = false;

  final List<String> _waterBorneDiseases = [
    'Diarrhea',
    'Cholera',
    'Typhoid',
    'Hepatitis A',
    'Dysentery',
    'Gastroenteritis',
    'Paratyphoid',
    'Shigellosis'
  ];

  final List<String> _severityLevels = [
    'Mild',
    'Moderate',
    'Severe',
    'Critical'
  ];

  final List<String> _symptoms = [
    'Frequent watery stools',
    'Dehydration',
    'Vomiting',
    'Fever',
    'Abdominal cramps',
    'Nausea',
    'Blood in stool',
    'Mucus in stool',
    'Loss of appetite',
    'Weakness/Fatigue',
    'Jaundice (yellow eyes/skin)',
    'Headache'
  ];

  final List<String> _waterSources = [
    'Borewell',
    'Hand Pump',
    'Community Well',
    'River/Stream',
    'Pond/Lake',
    'Piped Water Supply',
    'Spring Water',
    'Bottled Water',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        final locationName = LocationService.getFormattedLocation(position);
        setState(() {
          _currentPosition = position;
          _currentLocation = locationName;
        });
      } else {
        setState(() {
          _currentLocation = 'Location unavailable';
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = 'Location unavailable';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Disease Surveillance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationCard(),
            const SizedBox(height: 16),
            _buildPatientInfoCard(),
            const SizedBox(height: 16),
            _buildDiseaseInfoCard(),
            const SizedBox(height: 16),
            _buildSymptomsCard(),
            const SizedBox(height: 16),
            _buildWaterSourceCard(),
            const SizedBox(height: 16),
            _buildRiskAssessmentCard(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Reporting Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentLocation,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (_currentPosition != null) ...[
              const SizedBox(height: 8),
              Text(
                'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
                'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _patientNameController,
              decoration: InputDecoration(
                labelText: 'Patient Name (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['Male', 'Female', 'Other'].map((gender) {
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contact Number (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Disease Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Suspected Disease:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDisease,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _waterBorneDiseases.map((disease) {
                return DropdownMenuItem(
                  value: disease,
                  child: Text(disease),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDisease = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            const Text('Severity Level:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSeverity,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _severityLevels.map((severity) {
                return DropdownMenuItem(
                  value: severity,
                  child: Text(severity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            const Text('Onset Date:'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _onsetDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _onsetDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
                    const SizedBox(width: 8),
                    Text(_onsetDate.toString().split(' ')[0]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.healing, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Symptoms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Select all applicable symptoms:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _symptoms.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(symptom);
                      } else {
                        _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                  selectedColor: Color(0xFF1976D2).withOpacity(0.2),
                  checkmarkColor: Color(0xFF1976D2),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterSourceCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Water Source Used',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Primary water source used by patient:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _waterSourceUsed,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _waterSources.map((source) {
                return DropdownMenuItem(
                  value: source,
                  child: Text(source),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _waterSourceUsed = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Hospitalization Required'),
              value: _hospitalizationRequired,
              onChanged: (value) {
                setState(() {
                  _hospitalizationRequired = value ?? false;
                });
              },
              activeColor: Color(0xFF1976D2),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskAssessmentCard() {
    String riskLevel = _calculateRiskLevel();
    Color riskColor = _getRiskColor(riskLevel);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Risk Assessment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: riskColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.assessment, color: riskColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Outbreak Risk Level: $riskLevel',
                          style: TextStyle(
                            color: riskColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getRiskDescription(riskLevel),
                          style: TextStyle(color: riskColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateRiskLevel() {
    int riskScore = 0;
    
    // Severity scoring
    switch (_selectedSeverity) {
      case 'Critical':
        riskScore += 4;
        break;
      case 'Severe':
        riskScore += 3;
        break;
      case 'Moderate':
        riskScore += 2;
        break;
      case 'Mild':
        riskScore += 1;
        break;
    }
    
    // Disease scoring
    if (['Cholera', 'Typhoid', 'Dysentery'].contains(_selectedDisease)) {
      riskScore += 2;
    }
    
    // Water source scoring
    if (['River/Stream', 'Pond/Lake', 'Community Well'].contains(_waterSourceUsed)) {
      riskScore += 2;
    }
    
    // Hospitalization
    if (_hospitalizationRequired) {
      riskScore += 2;
    }
    
    // Symptoms count
    if (_selectedSymptoms.length > 5) {
      riskScore += 2;
    } else if (_selectedSymptoms.length > 3) {
      riskScore += 1;
    }
    
    if (riskScore >= 8) return 'Critical';
    if (riskScore >= 6) return 'High';
    if (riskScore >= 4) return 'Medium';
    return 'Low';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'Critical':
        return Colors.red[800]!;
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'Critical':
        return 'Immediate health authority notification required';
      case 'High':
        return 'Enhanced surveillance and rapid response needed';
      case 'Medium':
        return 'Monitor closely and implement preventive measures';
      case 'Low':
        return 'Standard monitoring and treatment protocols';
      default:
        return '';
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitDiseaseReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
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
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Submit Disease Report',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _submitDiseaseReport() async {
    if (_ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter patient age'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        String riskLevel = _calculateRiskLevel();
        Color riskColor = _getRiskColor(riskLevel);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disease report submitted successfully! Risk Level: $riskLevel'),
            backgroundColor: riskColor,
          ),
        );
        
        // Clear form
        _patientNameController.clear();
        _ageController.clear();
        _contactController.clear();
        setState(() {
          _selectedDisease = 'Diarrhea';
          _selectedSeverity = 'Mild';
          _selectedGender = 'Male';
          _selectedSymptoms.clear();
          _waterSourceUsed = 'Borewell';
          _onsetDate = DateTime.now();
          _hospitalizationRequired = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting report: ${e.toString()}'),
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
  void dispose() {
    _patientNameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
