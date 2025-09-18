import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/risk_map_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/chatbot_screen.dart';
import '../screens/reports_analytics_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_help_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/water_quality_dashboard_screen.dart';
import '../screens/community_health_reporting_screen.dart';
import '../screens/education_modules_screen.dart';
import '../screens/sms_dashboard_screen.dart';
import '../screens/offline_sync_dashboard_screen.dart';
import '../services/api_service.dart';
import '../widgets/auth_wrapper.dart';

class AppDrawer extends StatelessWidget {
  final String userType;

  const AppDrawer({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1976D2),
                  Color(0xFF1565C0),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/logo/logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FlowSafe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Health Surveillance System',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getUserTypeDisplay(userType),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Main Navigation
                _buildDrawerItem(
                  context,
                  Icons.home,
                  'Dashboard',
                  () => _navigateToScreen(context, DashboardScreen(userType: userType)),
                ),
                _buildDrawerItem(
                  context,
                  Icons.map,
                  'Risk Map',
                  () => _navigateToScreen(context, RiskMapScreen(userType: userType)),
                ),
                _buildDrawerItem(
                  context,
                  Icons.warning,
                  'Alerts',
                  () => _navigateToScreen(context, AlertsScreen(userType: userType)),
                ),
                _buildDrawerItem(
                  context,
                  Icons.smart_toy,
                  'AI Assistant',
                  () => _navigateToScreen(context, ChatbotScreen(userType: userType)),
                ),
                _buildDrawerItem(
                  context,
                  Icons.analytics,
                  'Reports & Analytics',
                  () => _navigateToScreen(context, ReportsAnalyticsScreen(userType: userType)),
                ),
                
                const Divider(),
                
                // Health & Safety Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Health & Safety',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                _buildDrawerItem(
                  context,
                  Icons.water_drop,
                  'Water Quality Monitoring',
                  () => _navigateToScreen(context, const WaterQualityDashboardScreen()),
                ),
                
                if (userType == 'asha_worker' || userType == 'community_volunteer')
                  _buildDrawerItem(
                    context,
                    Icons.health_and_safety,
                    'Community Health Reports',
                    () => _navigateToScreen(context, CommunityHealthReportingScreen(userType: userType)),
                  ),
                
                _buildDrawerItem(
                  context,
                  Icons.school,
                  'Health Education',
                  () => _navigateToScreen(context, const EducationModulesScreen()),
                ),
                
                if (userType == 'asha_worker' || userType == 'community_volunteer' || userType == 'health_official')
                  _buildDrawerItem(
                    context,
                    Icons.message,
                    'SMS Dashboard',
                    () => _navigateToScreen(context, const SMSDashboardScreen()),
                  ),
                
                _buildDrawerItem(
                  context,
                  Icons.sync,
                  'Offline Sync',
                  () => _navigateToScreen(context, const OfflineSyncDashboardScreen()),
                ),
                
                const Divider(),
                
                // Settings & Support
                _buildDrawerItem(
                  context,
                  Icons.person,
                  'Profile',
                  () => _navigateToScreen(context, ProfileScreen(userType: userType)),
                ),
                _buildDrawerItem(
                  context,
                  Icons.settings,
                  'Settings',
                  () => _navigateToScreen(context, SettingsScreen(userType: userType)),
                ),
                _buildDrawerItem(
                  context,
                  Icons.language,
                  'Language',
                  () => _navigateToScreen(context, const LanguageSelectionScreen()),
                ),
                _buildDrawerItem(
                  context,
                  Icons.help,
                  'Help & Support',
                  () => _navigateToScreen(context, const AboutHelpScreen()),
                ),
              ],
            ),
          ),
          
          // Logout Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1976D2)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  String _getUserTypeDisplay(String userType) {
    switch (userType.toLowerCase()) {
      case 'asha_worker':
        return 'ASHA Worker';
      case 'community_volunteer':
        return 'Community Volunteer';
      case 'health_official':
        return 'Health Official';
      case 'medical_professional':
        return 'Medical Professional';
      default:
        return 'User';
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                
                try {
                  await ApiService.logout();
                } catch (e) {
                  print('Error during logout: $e');
                }
                
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthWrapper()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
