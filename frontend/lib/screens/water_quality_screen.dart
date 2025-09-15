import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class WaterQualityScreen extends StatefulWidget {
  final String userType;
  
  const WaterQualityScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  bool _isLoading = false;
  Position? _currentPosition;
  String _currentLocation = 'Loading...';
  
  // Water quality parameters
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _turbidityController = TextEditingController();
  final TextEditingController _tdsController = TextEditingController();
  final TextEditingController _bacterialCountController = TextEditingController();
  final TextEditingController _chlorineController = TextEditingController();
  
  String _selectedWaterSource = 'Borewell';
  String _selectedTestMethod = 'Manual Test Kit';
  String _reportedBy = '';

  final List<String> _waterSources = [
    'Borewell',
    'Hand Pump',
    'Community Well',
    'River/Stream',
    'Pond/Lake',
    'Piped Water Supply',
    'Spring Water',
    'Other'
  ];

  final List<String> _testMethods = [
    'Manual Test Kit',
    'IoT Sensor',
    'Laboratory Analysis',
    'Visual Inspection'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _reportedBy = widget.userType == 'Health Worker' ? 'ASHA Worker' : 'Community Member';
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
          'Water Quality Monitoring',
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
            _buildWaterSourceCard(),
            const SizedBox(height: 16),
            _buildWaterQualityParameters(),
            const SizedBox(height: 16),
            _buildTestDetailsCard(),
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
                  'Current Location',
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
                  'Water Source Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Type of Water Source:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedWaterSource,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _waterSources.map((source) {
                return DropdownMenuItem(
                  value: source,
                  child: Text(source),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWaterSource = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterQualityParameters() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Water Quality Parameters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildParameterField('pH Level (6.5-8.5)', _phController, 'Enter pH value'),
            const SizedBox(height: 12),
            _buildParameterField('Turbidity (NTU)', _turbidityController, 'Enter turbidity value'),
            const SizedBox(height: 12),
            _buildParameterField('TDS (mg/L)', _tdsController, 'Enter TDS value'),
            const SizedBox(height: 12),
            _buildParameterField('Bacterial Count (CFU/100mL)', _bacterialCountController, 'Enter bacterial count'),
            const SizedBox(height: 12),
            _buildParameterField('Residual Chlorine (mg/L)', _chlorineController, 'Enter chlorine level'),
            const SizedBox(height: 16),
            _buildQualityIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            setState(() {}); // Trigger rebuild for quality indicator
          },
        ),
      ],
    );
  }

  Widget _buildQualityIndicator() {
    Color indicatorColor = Colors.grey;
    String qualityText = 'Enter values to assess quality';
    IconData indicatorIcon = Icons.help_outline;

    if (_phController.text.isNotEmpty || _turbidityController.text.isNotEmpty) {
      double? ph = double.tryParse(_phController.text);
      double? turbidity = double.tryParse(_turbidityController.text);
      
      bool isGoodQuality = true;
      
      if (ph != null && (ph < 6.5 || ph > 8.5)) isGoodQuality = false;
      if (turbidity != null && turbidity > 5) isGoodQuality = false;
      
      if (isGoodQuality) {
        indicatorColor = Colors.green;
        qualityText = 'Water Quality: Good';
        indicatorIcon = Icons.check_circle;
      } else {
        indicatorColor = Colors.red;
        qualityText = 'Water Quality: Poor - Requires Treatment';
        indicatorIcon = Icons.warning;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: indicatorColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(indicatorIcon, color: indicatorColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              qualityText,
              style: TextStyle(
                color: indicatorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestDetailsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                const Text(
                  'Test Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Testing Method:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedTestMethod,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _testMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTestMethod = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Reported by: $_reportedBy',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Date: ${DateTime.now().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitWaterQualityReport,
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
                'Submit Water Quality Report',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _submitWaterQualityReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Water quality report submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _phController.clear();
        _turbidityController.clear();
        _tdsController.clear();
        _bacterialCountController.clear();
        _chlorineController.clear();
        setState(() {
          _selectedWaterSource = 'Borewell';
          _selectedTestMethod = 'Manual Test Kit';
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
    _phController.dispose();
    _turbidityController.dispose();
    _tdsController.dispose();
    _bacterialCountController.dispose();
    _chlorineController.dispose();
    super.dispose();
  }
}
