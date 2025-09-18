import 'package:flutter/material.dart';
import 'clinic_data_entry_screen.dart';
import 'asha_worker_data_screen.dart';
import 'volunteer_data_screen.dart';
import 'field_survey_screen.dart';
import 'health_camp_data_screen.dart';
import 'emergency_report_screen.dart';

class HealthDataCollectionHub extends StatefulWidget {
  final String userType;

  const HealthDataCollectionHub({super.key, required this.userType});

  @override
  State<HealthDataCollectionHub> createState() => _HealthDataCollectionHubState();
}

class _HealthDataCollectionHubState extends State<HealthDataCollectionHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data Collection'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Health Data Collection Center',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Collect and manage health data from various sources',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal.shade100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Collection Options
              Text(
                'Data Collection Methods',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of data collection options
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  if (widget.userType == 'health_official' || widget.userType == 'clinic_staff')
                    _buildDataCollectionCard(
                      title: 'Clinic Data Entry',
                      subtitle: 'Patient records, diagnostics, treatments',
                      icon: Icons.local_hospital,
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClinicDataEntryScreen(userType: widget.userType),
                        ),
                      ),
                    ),

                  if (widget.userType == 'asha_worker' || widget.userType == 'health_official')
                    _buildDataCollectionCard(
                      title: 'ASHA Worker Data',
                      subtitle: 'Community health visits, screenings',
                      icon: Icons.personal_injury,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AshaWorkerDataScreen(userType: widget.userType),
                        ),
                      ),
                    ),

                  if (widget.userType == 'community_volunteer' || widget.userType == 'health_official')
                    _buildDataCollectionCard(
                      title: 'Volunteer Data',
                      subtitle: 'Community surveys, awareness programs',
                      icon: Icons.volunteer_activism,
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerDataScreen(userType: widget.userType),
                        ),
                      ),
                    ),

                  _buildDataCollectionCard(
                    title: 'Field Survey',
                    subtitle: 'Door-to-door health surveys',
                    icon: Icons.explore,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FieldSurveyScreen(userType: widget.userType),
                      ),
                    ),
                  ),

                  _buildDataCollectionCard(
                    title: 'Health Camp Data',
                    subtitle: 'Medical camp registrations, screenings',
                    icon: Icons.medical_services,
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthCampDataScreen(userType: widget.userType),
                      ),
                    ),
                  ),

                  _buildDataCollectionCard(
                    title: 'Emergency Reports',
                    subtitle: 'Urgent health incidents, outbreaks',
                    icon: Icons.emergency,
                    color: Colors.deepOrange,
                    onTap: () => _showEmergencyReportDialog(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Statistics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.teal.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Today\'s Data Collection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickStat('Records', '23', Icons.assignment),
                        ),
                        Expanded(
                          child: _buildQuickStat('Surveys', '12', Icons.poll),
                        ),
                        Expanded(
                          child: _buildQuickStat('Pending', '5', Icons.pending),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCollectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showEmergencyReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Report'),
          ],
        ),
        content: const Text(
          'Emergency reports require immediate attention. '
          'This will notify health authorities immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _createEmergencyReport();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Create Emergency Report'),
          ),
        ],
      ),
    );
  }

  void _createEmergencyReport() {
    // Navigate to emergency report screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyReportScreen(userType: widget.userType),
      ),
    );
  }
}
