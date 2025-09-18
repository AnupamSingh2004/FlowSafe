import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/localized_text.dart';
import '../services/water_quality_service.dart';
import 'water_quality_details_screen.dart';

class WaterQualityDashboardScreen extends StatefulWidget {
  const WaterQualityDashboardScreen({Key? key}) : super(key: key);

  @override
  State<WaterQualityDashboardScreen> createState() => _WaterQualityDashboardScreenState();
}

class _WaterQualityDashboardScreenState extends State<WaterQualityDashboardScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final WaterQualityService _waterQualityService = WaterQualityService();
  List<WaterSource> waterSources = [];
  bool isLoading = true;
  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadWaterQualityData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWaterQualityData() async {
    setState(() => isLoading = true);
    try {
      final sources = await _waterQualityService.getWaterSources();
      setState(() {
        waterSources = sources;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Failed to load water quality data: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const LocalizedText('water_quality_monitoring'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.map), text: 'Map View'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWaterQualityData,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => selectedFilter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Sources')),
              const PopupMenuItem(value: 'safe', child: Text('Safe')),
              const PopupMenuItem(value: 'warning', child: Text('Warning')),
              const PopupMenuItem(value: 'danger', child: Text('Dangerous')),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildMapTab(),
                _buildAnalyticsTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWaterSourceDialog(),
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOverviewTab() {
    final filteredSources = _filterWaterSources();
    
    return RefreshIndicator(
      onRefresh: _loadWaterQualityData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildRecentAlerts(),
            const SizedBox(height: 24),
            _buildWaterSourcesList(filteredSources),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final safeCount = waterSources.where((s) => s.safetyLevel == 'safe').length;
    final warningCount = waterSources.where((s) => s.safetyLevel == 'warning').length;
    final dangerCount = waterSources.where((s) => s.safetyLevel == 'danger').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LocalizedText(
          'water_quality_overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSummaryCard('Safe Sources', safeCount, Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _buildSummaryCard('Warning', warningCount, Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _buildSummaryCard('Dangerous', dangerCount, Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlerts() {
    final recentAlerts = waterSources
        .where((s) => s.safetyLevel != 'safe')
        .take(3)
        .toList();

    if (recentAlerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LocalizedText(
          'recent_alerts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...recentAlerts.map((source) => _buildAlertCard(source)).toList(),
      ],
    );
  }

  Widget _buildAlertCard(WaterSource source) {
    final color = source.safetyLevel == 'danger' ? Colors.red : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.warning, color: color),
        title: Text(source.name),
        subtitle: Text('${source.location} • ${source.getMainIssue()}'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaterQualityDetailsScreen(source: source),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaterSourcesList(List<WaterSource> sources) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LocalizedText(
          'water_sources',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sources.length,
          itemBuilder: (context, index) {
            final source = sources[index];
            return _buildWaterSourceCard(source);
          },
        ),
      ],
    );
  }

  Widget _buildWaterSourceCard(WaterSource source) {
    Color statusColor;
    IconData statusIcon;
    
    switch (source.safetyLevel) {
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaterQualityDetailsScreen(source: source),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      source.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    source.safetyLevel.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                source.location,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildMetricChip('pH', source.phLevel.toStringAsFixed(1)),
                  const SizedBox(width: 8),
                  _buildMetricChip('Turbidity', '${source.turbidity.toStringAsFixed(1)} NTU'),
                  const SizedBox(width: 8),
                  _buildMetricChip('Bacteria', source.bacterialCount > 0 ? 'Present' : 'Safe'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Last updated: ${_formatDateTime(source.lastUpdated)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMapTab() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(26.2006, 92.9376), // Guwahati, Assam
        initialZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.flowsafe.app',
        ),
        MarkerLayer(
          markers: waterSources.map((source) {
            Color markerColor;
            switch (source.safetyLevel) {
              case 'safe':
                markerColor = Colors.green;
                break;
              case 'warning':
                markerColor = Colors.orange;
                break;
              case 'danger':
                markerColor = Colors.red;
                break;
              default:
                markerColor = Colors.grey;
            }

            return Marker(
              width: 40,
              height: 40,
              point: LatLng(source.latitude, source.longitude),
              child: GestureDetector(
                onTap: () {
                  _showWaterSourcePopup(source);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: markerColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LocalizedText(
            'water_quality_trends',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTrendCard('pH Levels', 'Average: 7.2', Icons.science, Colors.blue),
          _buildTrendCard('Turbidity', 'Average: 2.1 NTU', Icons.visibility, Colors.orange),
          _buildTrendCard('Bacterial Count', '12% sources affected', Icons.bug_report, Colors.red),
          const SizedBox(height: 24),
          _buildMonthlyTrends(),
        ],
      ),
    );
  }

  Widget _buildTrendCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Water Quality Trends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Chart Placeholder\n(Integration with charts_flutter needed)',
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

  List<WaterSource> _filterWaterSources() {
    if (selectedFilter == 'all') return waterSources;
    return waterSources.where((source) => source.safetyLevel == selectedFilter).toList();
  }

  void _showWaterSourcePopup(WaterSource source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(source.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${source.location}'),
            Text('Safety Level: ${source.safetyLevel.toUpperCase()}'),
            Text('pH Level: ${source.phLevel.toStringAsFixed(1)}'),
            Text('Turbidity: ${source.turbidity.toStringAsFixed(1)} NTU'),
            Text('Bacterial Count: ${source.bacterialCount}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WaterQualityDetailsScreen(source: source),
                ),
              );
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  void _showAddWaterSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Water Source'),
        content: const Text('Feature coming soon: Add new water sources for monitoring'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
