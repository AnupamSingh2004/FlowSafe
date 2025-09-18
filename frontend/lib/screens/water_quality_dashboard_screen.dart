import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
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
  
  // Analytics data
  late Map<String, dynamic> _analyticsData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeAnalyticsData();
    _loadWaterQualityData();
  }

  void _initializeAnalyticsData() {
    _analyticsData = {
      'monthlyTrends': [
        {'month': 'Jan', 'ph': 7.1, 'turbidity': 2.3, 'bacterial': 5},
        {'month': 'Feb', 'ph': 7.2, 'turbidity': 2.1, 'bacterial': 8},
        {'month': 'Mar', 'ph': 7.0, 'turbidity': 2.5, 'bacterial': 12},
        {'month': 'Apr', 'ph': 7.3, 'turbidity': 1.9, 'bacterial': 6},
        {'month': 'May', 'ph': 7.2, 'turbidity': 2.0, 'bacterial': 10},
        {'month': 'Jun', 'ph': 7.4, 'turbidity': 1.8, 'bacterial': 4},
        {'month': 'Jul', 'ph': 7.1, 'turbidity': 2.2, 'bacterial': 15},
        {'month': 'Aug', 'ph': 7.2, 'turbidity': 2.1, 'bacterial': 9},
      ],
      'safetyLevels': {
        'Safe': 65.2,
        'Moderate': 23.8,
        'Poor': 8.5,
        'Critical': 2.5,
      },
      'parameters': {
        'averagePH': 7.2,
        'averageTurbidity': 2.1,
        'bacterialSources': 12,
        'totalSources': 142,
        'complianceRate': 87.5,
      },
      'weeklyData': [
        {'day': 'Mon', 'tests': 18, 'violations': 2},
        {'day': 'Tue', 'tests': 22, 'violations': 1},
        {'day': 'Wed', 'tests': 25, 'violations': 3},
        {'day': 'Thu', 'tests': 20, 'violations': 0},
        {'day': 'Fri', 'tests': 28, 'violations': 4},
        {'day': 'Sat', 'tests': 15, 'violations': 1},
        {'day': 'Sun', 'tests': 12, 'violations': 0},
      ],
    };
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
          
          // Summary Cards Row
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsSummaryCard(
                  'Total Sources',
                  _analyticsData['parameters']['totalSources'].toString(),
                  Icons.water,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticsSummaryCard(
                  'Safe Sources',
                  '${(_analyticsData['parameters']['totalSources'] * _analyticsData['safetyLevels']['Safe'] / 100).round()}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsSummaryCard(
                  'Critical Sources',
                  '${(_analyticsData['parameters']['totalSources'] * _analyticsData['safetyLevels']['Critical'] / 100).round()}',
                  Icons.warning,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticsSummaryCard(
                  'This Month Tests',
                  '168',
                  Icons.assignment,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTrendCard(
            'pH Levels', 
            'Average: ${_analyticsData['parameters']['averagePH']}', 
            Icons.science, 
            Colors.blue
          ),
          _buildTrendCard(
            'Turbidity', 
            'Average: ${_analyticsData['parameters']['averageTurbidity']} NTU', 
            Icons.visibility, 
            Colors.orange
          ),
          _buildTrendCard(
            'Bacterial Count', 
            '${_analyticsData['parameters']['bacterialSources']}% sources affected', 
            Icons.bug_report, 
            Colors.red
          ),
          _buildTrendCard(
            'Compliance Rate', 
            '${_analyticsData['parameters']['complianceRate']}%', 
            Icons.check_circle, 
            Colors.green
          ),
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
    return Column(
      children: [
        // pH and Turbidity Trends
        Card(
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
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final months = _analyticsData['monthlyTrends']
                                  .map<String>((data) => data['month'] as String)
                                  .toList();
                              if (value.toInt() >= 0 && value.toInt() < months.length) {
                                return Text(
                                  months[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        // pH Line
                        LineChartBarData(
                          spots: List.generate(
                            _analyticsData['monthlyTrends'].length,
                            (index) => FlSpot(
                              index.toDouble(),
                              _analyticsData['monthlyTrends'][index]['ph'].toDouble(),
                            ),
                          ),
                          isCurved: true,
                          color: Colors.blue.shade600,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: const FlDotData(show: true),
                        ),
                        // Turbidity Line
                        LineChartBarData(
                          spots: List.generate(
                            _analyticsData['monthlyTrends'].length,
                            (index) => FlSpot(
                              index.toDouble(),
                              _analyticsData['monthlyTrends'][index]['turbidity'].toDouble(),
                            ),
                          ),
                          isCurved: true,
                          color: Colors.orange.shade600,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('pH Levels', Colors.blue.shade600),
                    const SizedBox(width: 20),
                    _buildLegendItem('Turbidity (NTU)', Colors.orange.shade600),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Safety Level Distribution Pie Chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Water Source Safety Distribution',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _analyticsData['safetyLevels']
                          .entries
                          .map<PieChartSectionData>((entry) {
                        final colors = {
                          'Safe': Colors.green.shade600,
                          'Moderate': Colors.yellow.shade700,
                          'Poor': Colors.orange.shade600,
                          'Critical': Colors.red.shade600,
                        };
                        return PieChartSectionData(
                          value: entry.value,
                          title: '${entry.value.toStringAsFixed(1)}%',
                          color: colors[entry.key] ?? Colors.grey,
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Pie Chart Legend
                Wrap(
                  alignment: WrapAlignment.center,
                  children: _analyticsData['safetyLevels'].entries.map<Widget>((entry) {
                    final colors = {
                      'Safe': Colors.green.shade600,
                      'Moderate': Colors.yellow.shade700,
                      'Poor': Colors.orange.shade600,
                      'Critical': Colors.red.shade600,
                    };
                    return Container(
                      margin: const EdgeInsets.all(4),
                      child: _buildLegendItem(entry.key, colors[entry.key] ?? Colors.grey),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Weekly Testing Activity Bar Chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Testing Activity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 30,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = _analyticsData['weeklyData']
                                  .map<String>((data) => data['day'] as String)
                                  .toList();
                              if (value.toInt() >= 0 && value.toInt() < days.length) {
                                return Text(
                                  days[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _analyticsData['weeklyData']
                          .asMap()
                          .entries
                          .map<BarChartGroupData>((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value['tests'].toDouble(),
                              color: Colors.blue.shade600,
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Daily water quality tests conducted',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bacterial Contamination Trend
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bacterial Contamination Trends',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final months = _analyticsData['monthlyTrends']
                                  .map<String>((data) => data['month'] as String)
                                  .toList();
                              if (value.toInt() >= 0 && value.toInt() < months.length) {
                                return Text(
                                  months[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            _analyticsData['monthlyTrends'].length,
                            (index) => FlSpot(
                              index.toDouble(),
                              _analyticsData['monthlyTrends'][index]['bacterial'].toDouble(),
                            ),
                          ),
                          isCurved: true,
                          color: Colors.red.shade600,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.red.shade100,
                          ),
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Percentage of sources with bacterial contamination',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
