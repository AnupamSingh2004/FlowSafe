import 'package:flutter/material.dart';
import '../services/offline_data_service.dart';

class OfflineSyncScreen extends StatefulWidget {
  const OfflineSyncScreen({Key? key}) : super(key: key);

  @override
  State<OfflineSyncScreen> createState() => _OfflineSyncScreenState();
}

class _OfflineSyncScreenState extends State<OfflineSyncScreen> {
  final OfflineDataService _offlineService = OfflineDataService();
  List<Map<String, dynamic>> _offlineReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfflineReports();
    _offlineService.addListener(_onOfflineDataChanged);
  }

  @override
  void dispose() {
    _offlineService.removeListener(_onOfflineDataChanged);
    super.dispose();
  }

  void _onOfflineDataChanged() {
    if (mounted) {
      _loadOfflineReports();
    }
  }

  Future<void> _loadOfflineReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _offlineService.initialize();
      final reports = _offlineService.getAllOfflineReports();
      setState(() {
        _offlineReports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      appBar: AppBar(
        title: const Text(
          'Offline Data Sync',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_offlineReports.isNotEmpty)
            IconButton(
              onPressed: _syncAllData,
              icon: _offlineService.isSyncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.sync),
              tooltip: 'Sync All Data',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_offlineReports.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadOfflineReports,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSyncStatusCard(),
            const SizedBox(height: 16),
            _buildOfflineReportsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_done,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'All data is synced!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No offline reports waiting to be synchronized.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSyncStatusCard() {
    final syncStatus = _offlineService.getSyncStatus();
    
    return Card(
      elevation: 2,
      color: const Color(0xFFBBDEFB), // Light blue card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    syncStatus['is_syncing'] ? Icons.sync : Icons.cloud_upload,
                    color: const Color(0xFF1976D2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        syncStatus['is_syncing'] ? 'Syncing Data...' : 'Offline Data Status',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      Text(
                        '${syncStatus['total_reports']} reports pending sync',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!syncStatus['is_syncing'] && syncStatus['total_reports'] > 0)
                  ElevatedButton.icon(
                    onPressed: _syncAllData,
                    icon: const Icon(Icons.sync, size: 16),
                    label: const Text('Sync All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusItem(
                  'Water Quality',
                  syncStatus['water_quality_reports'].toString(),
                  Icons.water_drop,
                  const Color(0xFF1976D2),
                ),
                const SizedBox(width: 16),
                _buildStatusItem(
                  'Disease Reports',
                  syncStatus['disease_reports'].toString(),
                  Icons.medical_services,
                  const Color(0xFF42A5F5),
                ),
                const SizedBox(width: 16),
                _buildStatusItem(
                  'Community',
                  syncStatus['community_reports'].toString(),
                  Icons.people,
                  const Color(0xFF64B5F6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineReportsList() {
    return Card(
      elevation: 2,
      color: const Color(0xFFBBDEFB), // Light blue card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offline Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _offlineReports.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _buildReportItem(_offlineReports[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    IconData icon;
    Color color;
    String title;
    
    switch (report['type']) {
      case 'water_quality':
        icon = Icons.water_drop;
        color = const Color(0xFF1976D2);
        title = 'Water Quality Report';
        break;
      case 'disease_surveillance':
        icon = Icons.medical_services;
        color = const Color(0xFF42A5F5);
        title = 'Disease Surveillance Report';
        break;
      case 'community_report':
        icon = Icons.people;
        color = const Color(0xFF64B5F6);
        title = 'Community Report';
        break;
      default:
        icon = Icons.description;
        color = Colors.grey;
        title = 'Unknown Report';
    }

    final createdTime = DateTime.parse(report['offline_id']);
    final timeAgo = _getTimeAgo(createdTime);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Created: $timeAgo'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Pending Sync',
              style: TextStyle(
                fontSize: 10,
                color: Colors.orange[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () => _deleteReport(report['offline_id']),
        icon: const Icon(Icons.delete, color: Colors.red),
        tooltip: 'Delete Report',
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _syncAllData() async {
    try {
      final success = await _offlineService.syncAllData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success 
                  ? 'All data synced successfully!'
                  : 'Some reports failed to sync. Please try again.',
            ),
            backgroundColor: success ? Colors.green : Colors.orange,
          ),
        );
        
        if (success) {
          _loadOfflineReports();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sync data. Please check your connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteReport(String offlineId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure you want to delete this offline report? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _offlineService.deleteOfflineReport(offlineId);
      _loadOfflineReports();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
