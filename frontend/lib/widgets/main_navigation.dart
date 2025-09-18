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
import '../screens/offline_sync_screen.dart';
import '../screens/water_quality_dashboard_screen.dart';
import '../screens/community_health_reporting_screen.dart';
import '../screens/education_modules_screen.dart';
import '../screens/sms_dashboard_screen.dart';
import '../screens/offline_sync_dashboard_screen.dart';
import '../screens/health_data_collection_hub.dart';
import '../services/api_service.dart';
import '../widgets/auth_wrapper.dart';
import '../widgets/localized_text.dart';

class MainNavigation extends StatefulWidget {
  final String userType;
  
  const MainNavigation({Key? key, required this.userType}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(
        userType: widget.userType,
        onNavigateToRiskMap: () => _onItemTapped(1),
        onNavigateToAlerts: () => _onItemTapped(2),
      ),
      RiskMapScreen(userType: widget.userType),
      AlertsScreen(userType: widget.userType),
      ChatbotScreen(userType: widget.userType),
      ReportsAnalyticsScreen(userType: widget.userType),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        title: _selectedIndex == 0 ? Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/logo/logo.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.water_drop, color: Colors.white);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'FlowSafe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ) : null,
        actions: _selectedIndex == 0 ? [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.satellite,
                  color: Colors.green,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ] : null,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildSideMenu(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: getLocalizedText(context, 'home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: getLocalizedText(context, 'map'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.warning),
            label: getLocalizedText(context, 'alerts'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.smart_toy),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: getLocalizedText(context, 'reports'),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildSettingsMenuItems(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1976D2),
            Color(0xFF1565C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/logo/logo.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          const Text(
            'FlowSafe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          Text(
            _getUserTypeDisplayName(widget.userType),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.person, getLocalizedText(context, 'profile'), () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProfileScreen(userType: widget.userType),
          ));
        }),
        _buildMenuItem(Icons.sync, 'Offline Sync', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const OfflineSyncScreen(),
          ));
        }),
        _buildMenuItem(Icons.settings, getLocalizedText(context, 'settings'), () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SettingsScreen(userType: widget.userType),
          ));
        }),
        _buildMenuItem(Icons.language, getLocalizedText(context, 'language') + ' / भाषा', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const LanguageSelectionScreen(),
          ));
        }),
        
        const Divider(),
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
        
        _buildMenuItem(Icons.data_usage, 'Health Data Collection', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => HealthDataCollectionHub(userType: widget.userType),
          ));
        }),
        
        _buildMenuItem(Icons.water_drop, 'Water Quality Monitoring', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const WaterQualityDashboardScreen(),
          ));
        }),
        
        if (widget.userType == 'asha_worker' || widget.userType == 'community_volunteer')
          _buildMenuItem(Icons.health_and_safety, 'Community Health Reports', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CommunityHealthReportingScreen(userType: widget.userType),
            ));
          }),
        
        _buildMenuItem(Icons.school, 'Health Education', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const EducationModulesScreen(),
          ));
        }),
        
        if (widget.userType == 'asha_worker' || widget.userType == 'community_volunteer' || widget.userType == 'health_official')
          _buildMenuItem(Icons.message, 'SMS Dashboard', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const SMSDashboardScreen(),
            ));
          }),
        
        _buildMenuItem(Icons.sync, 'Offline Sync', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const OfflineSyncDashboardScreen(),
          ));
        }),
        
        const Divider(),
        
        _buildMenuItem(Icons.help, 'Help & Support', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AboutHelpScreen(),
          ));
        }),
        _buildMenuItem(Icons.logout, 'Logout', () {
          _showLogoutDialog();
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF1976D2),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  String _getUserTypeDisplayName(String userType) {
    switch (userType) {
      case 'ASHA/ANM':
        return 'ASHA/ANM Worker';
      case 'PHC':
        return 'PHC/District Official';
      case 'Rural':
        return 'Rural Household';
      case 'Tourist':
        return 'Tourist';
      default:
        return 'User';
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                final result = await ApiService.logout();
                if (mounted) {
                  Navigator.of(context).pop(); // Close loading dialog
                  if (result['success']) {
                    // Navigate to login screen (AuthWrapper will handle the redirect)
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AuthWrapper()),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'] ?? 'Logout failed')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  Navigator.of(context).pop(); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout failed')),
                  );
                }
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
