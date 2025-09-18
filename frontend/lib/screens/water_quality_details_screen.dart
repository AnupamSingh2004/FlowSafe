import 'package:flutter/material.dart';
import '../services/water_quality_service.dart';
import '../widgets/localized_text.dart';

class WaterQualityDetailsScreen extends StatefulWidget {
  final WaterSource source;

  const WaterQualityDetailsScreen({Key? key, required this.source}) : super(key: key);

  @override
  State<WaterQualityDetailsScreen> createState() => _WaterQualityDetailsScreenState();
}

class _WaterQualityDetailsScreenState extends State<WaterQualityDetailsScreen> {
  final WaterQualityService _waterQualityService = WaterQualityService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(widget.source.name),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh data
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildLocationCard(),
            const SizedBox(height: 16),
            _buildParametersCard(),
            const SizedBox(height: 16),
            _buildHistoryCard(),
            const SizedBox(height: 16),
            _buildActionsCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReadingDialog,
        backgroundColor: const Color(0xFF1976D2),
        label: const Text('Add Reading', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (widget.source.safetyLevel) {
      case 'safe':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'SAFE FOR CONSUMPTION';
        break;
      case 'warning':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        statusText = 'REQUIRES MONITORING';
        break;
      case 'danger':
        statusColor = Colors.red;
        statusIcon = Icons.dangerous;
        statusText = 'UNSAFE - TREATMENT REQUIRED';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'STATUS UNKNOWN';
    }

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: statusColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.source.getMainIssue(),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${_formatDateTime(widget.source.lastUpdated)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1976D2)),
                SizedBox(width: 8),
                Text(
                  'Location Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Address', widget.source.location),
            _buildInfoRow('Type', widget.source.type.toUpperCase()),
            _buildInfoRow('Coordinates', 
                '${widget.source.latitude.toStringAsFixed(4)}, ${widget.source.longitude.toStringAsFixed(4)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildParametersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.science, color: Color(0xFF1976D2)),
                SizedBox(width: 8),
                Text(
                  'Water Quality Parameters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildParameterRow('pH Level', widget.source.phLevel.toStringAsFixed(1), 
                'Normal: 6.5-8.5', _getParameterStatus(widget.source.phLevel, 6.5, 8.5)),
            _buildParameterRow('Turbidity', '${widget.source.turbidity.toStringAsFixed(1)} NTU', 
                'Normal: <5 NTU', _getParameterStatus(widget.source.turbidity, 0, 5)),
            _buildParameterRow('Bacterial Count', '${widget.source.bacterialCount} CFU/ml', 
                'Safe: <10 CFU/ml', widget.source.bacterialCount < 10 ? 'safe' : 'danger'),
            _buildParameterRow('Dissolved Oxygen', '${widget.source.dissolvedOxygen.toStringAsFixed(1)} mg/L', 
                'Good: >6 mg/L', widget.source.dissolvedOxygen > 6 ? 'safe' : 'warning'),
            _buildParameterRow('Temperature', '${widget.source.temperature.toStringAsFixed(1)}°C', 
                'Normal: 15-25°C', _getParameterStatus(widget.source.temperature, 15, 25)),
            _buildParameterRow('Conductivity', '${widget.source.conductivity.toStringAsFixed(0)} μS/cm', 
                'Good: <500 μS/cm', widget.source.conductivity < 500 ? 'safe' : 'warning'),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String parameter, String value, String reference, String status) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'safe':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'warning':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'danger':
        statusColor = Colors.red;
        statusIcon = Icons.dangerous;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parameter,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  reference,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: statusColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Color(0xFF1976D2)),
                SizedBox(width: 8),
                Text(
                  'Recent Readings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Historical data chart\n(Coming soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.build, color: Color(0xFF1976D2)),
                SizedBox(width: 8),
                Text(
                  'Recommended Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._getRecommendedActions().map((action) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right, color: Color(0xFF1976D2), size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(action)),
                  ],
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getParameterStatus(double value, double min, double max) {
    if (value >= min && value <= max) return 'safe';
    if (value < min - (min * 0.2) || value > max + (max * 0.2)) return 'danger';
    return 'warning';
  }

  List<String> _getRecommendedActions() {
    List<String> actions = [];
    
    if (widget.source.bacterialCount > 10) {
      actions.add('Implement water disinfection treatment');
      actions.add('Test for specific bacterial strains');
    }
    
    if (widget.source.phLevel < 6.5 || widget.source.phLevel > 8.5) {
      actions.add('Adjust pH levels using appropriate chemicals');
    }
    
    if (widget.source.turbidity > 5) {
      actions.add('Install filtration system to reduce turbidity');
    }
    
    if (widget.source.dissolvedOxygen < 6) {
      actions.add('Improve water aeration system');
    }
    
    if (actions.isEmpty) {
      actions.add('Continue regular monitoring');
      actions.add('Maintain current water treatment protocols');
    } else {
      actions.add('Schedule follow-up testing within 24-48 hours');
      actions.add('Notify local health authorities');
    }
    
    return actions;
  }

  void _shareReport() {
    // Implementation for sharing water quality report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report sharing feature coming soon'),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }

  void _showAddReadingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Reading'),
        content: const Text(
          'This feature will allow field workers to add new water quality readings. Coming soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add reading form
            },
            child: const Text('Add Reading'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
