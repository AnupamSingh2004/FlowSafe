import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/health_data_service.dart';

class FieldSurveyScreen extends StatefulWidget {
  final String userType;

  const FieldSurveyScreen({super.key, required this.userType});

  @override
  State<FieldSurveyScreen> createState() => _FieldSurveyScreenState();
}

class _FieldSurveyScreenState extends State<FieldSurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _householdIdController = TextEditingController();
  final _householdHeadController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _observationsController = TextEditingController();
  final _recommendationsController = TextEditingController();

  String _surveyType = 'Door-to-Door Health Survey';
  String _areaType = 'Urban';
  String _householdType = 'Nuclear Family';
  DateTime _surveyDate = DateTime.now();
  bool _safeWaterAccess = false;
  bool _sanitationFacilities = false;
  bool _electricityAvailable = false;
  bool _solidWasteManagement = false;
  bool _vaccinationUpToDate = false;
  bool _chronicDiseasePresent = false;
  bool _pregnantWomenPresent = false;
  bool _elderlyNeedCare = false;
  bool _childrenMalnourished = false;
  bool _isLoading = false;

  final List<String> _surveyTypes = [
    'Door-to-Door Health Survey',
    'Community Health Assessment',
    'Disease Surveillance Survey',
    'Nutrition Survey',
    'Immunization Coverage Survey',
    'Water & Sanitation Survey',
    'Maternal Health Survey',
    'Child Health Survey',
  ];

  final List<String> _areaTypes = ['Urban', 'Rural', 'Semi-Urban', 'Tribal'];
  final List<String> _householdTypes = [
    'Nuclear Family',
    'Joint Family',
    'Single Person',
    'Single Parent',
    'Extended Family',
  ];

  int _totalMembers = 1;
  int _maleMembers = 0;
  int _femaleMembers = 0;
  int _childrenUnder5 = 0;
  int _children5to18 = 0;
  int _adults18to60 = 0;
  int _elderlyAbove60 = 0;

  String _incomeRange = 'Below 10,000';

  // Analytics data
  bool _showAnalytics = false;
  late Map<String, dynamic> _analyticsData;

  final List<String> _incomeRanges = [
    'Below 10,000',
    '10,000 - 25,000',
    '25,000 - 50,000',
    '50,000 - 1,00,000',
    'Above 1,00,000',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnalyticsData();
  }

  void _initializeAnalyticsData() {
    _analyticsData = {
      'totalSurveys': 1247,
      'completionRate': 87.5,
      'averageHouseholdSize': 4.2,
      'monthlyTrends': [
        {'month': 'Jan', 'surveys': 98, 'completion': 85},
        {'month': 'Feb', 'surveys': 112, 'completion': 88},
        {'month': 'Mar', 'surveys': 156, 'completion': 91},
        {'month': 'Apr', 'surveys': 134, 'completion': 86},
        {'month': 'May', 'surveys': 187, 'completion': 89},
        {'month': 'Jun', 'surveys': 201, 'completion': 92},
        {'month': 'Jul', 'surveys': 178, 'completion': 87},
        {'month': 'Aug', 'surveys': 181, 'completion': 85},
      ],
      'surveyTypes': {
        'Door-to-Door Health Survey': 45.2,
        'Community Health Assessment': 18.7,
        'Disease Surveillance Survey': 12.3,
        'Nutrition Survey': 8.9,
        'Water & Sanitation Survey': 7.8,
        'Others': 7.1,
      },
      'areaDistribution': {
        'Urban': 52.3,
        'Rural': 31.8,
        'Semi-Urban': 12.4,
        'Tribal': 3.5,
      },
      'healthIndicators': {
        'safeWaterAccess': 78.5,
        'sanitationFacilities': 82.3,
        'electricityAvailable': 91.2,
        'vaccinationUpToDate': 76.8,
        'chronicDiseasePresent': 23.7,
      },
    };
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
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
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.analytics,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Field Survey Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Data Insights & Trends',
                    style: TextStyle(
                      color: Colors.orange.shade100,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Key Metrics Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Surveys',
                  _analyticsData['totalSurveys'].toString(),
                  Icons.assignment,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Completion Rate',
                  '${_analyticsData['completionRate']}%',
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
                child: _buildMetricCard(
                  'Avg Household Size',
                  _analyticsData['averageHouseholdSize'].toString(),
                  Icons.people,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Safe Water Access',
                  '${_analyticsData['healthIndicators']['safeWaterAccess']}%',
                  Icons.water_drop,
                  Colors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Monthly Survey Trends Chart
          _buildSectionCard(
            title: 'Monthly Survey Trends',
            icon: Icons.trending_up,
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.all(16),
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
                            final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
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
                            _analyticsData['monthlyTrends'][index]['surveys'].toDouble(),
                          ),
                        ),
                        isCurved: true,
                        color: Colors.orange.shade600,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.orange.shade100,
                        ),
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Survey Types Distribution
          _buildSectionCard(
            title: 'Survey Types Distribution',
            icon: Icons.pie_chart,
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: PieChart(
                  PieChartData(
                    sections: _analyticsData['surveyTypes']
                        .entries
                        .map<PieChartSectionData>((entry) {
                      final colors = [
                        Colors.orange.shade700,
                        Colors.blue.shade600,
                        Colors.green.shade600,
                        Colors.purple.shade600,
                        Colors.red.shade600,
                        Colors.cyan.shade600,
                      ];
                      final index = _analyticsData['surveyTypes'].keys.toList().indexOf(entry.key);
                      return PieChartSectionData(
                        value: entry.value,
                        title: '${entry.value.toStringAsFixed(1)}%',
                        color: colors[index % colors.length],
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 10,
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
              // Legend
              Wrap(
                children: _analyticsData['surveyTypes'].entries.map<Widget>((entry) {
                  final colors = [
                    Colors.orange.shade700,
                    Colors.blue.shade600,
                    Colors.green.shade600,
                    Colors.purple.shade600,
                    Colors.red.shade600,
                    Colors.cyan.shade600,
                  ];
                  final index = _analyticsData['surveyTypes'].keys.toList().indexOf(entry.key);
                  return Container(
                    margin: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          entry.key,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Area Distribution
          _buildSectionCard(
            title: 'Area Type Distribution',
            icon: Icons.location_on,
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 60,
                    barTouchData: BarTouchData(enabled: false),
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
                            final areas = _analyticsData['areaDistribution'].keys.toList();
                            if (value.toInt() >= 0 && value.toInt() < areas.length) {
                              return Text(
                                areas[value.toInt()],
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
                    barGroups: _analyticsData['areaDistribution']
                        .entries
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final colors = [
                        Colors.orange.shade600,
                        Colors.blue.shade600,
                        Colors.green.shade600,
                        Colors.purple.shade600,
                      ];
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.value,
                            color: colors[entry.key % colors.length],
                            width: 30,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          // Health Indicators
          _buildSectionCard(
            title: 'Health Indicators Overview',
            icon: Icons.health_and_safety,
            children: [
              ..._analyticsData['healthIndicators'].entries.map<Widget>((entry) {
                final icons = {
                  'safeWaterAccess': Icons.water_drop,
                  'sanitationFacilities': Icons.bathroom,
                  'electricityAvailable': Icons.electrical_services,
                  'vaccinationUpToDate': Icons.vaccines,
                  'chronicDiseasePresent': Icons.sick,
                };
                final labels = {
                  'safeWaterAccess': 'Safe Water Access',
                  'sanitationFacilities': 'Sanitation Facilities',
                  'electricityAvailable': 'Electricity Available',
                  'vaccinationUpToDate': 'Vaccination Up-to-Date',
                  'chronicDiseasePresent': 'Chronic Disease Present',
                };
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icons[entry.key] ?? Icons.health_and_safety,
                        color: Colors.orange.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              labels[entry.key] ?? entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: entry.value / 100,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${entry.value.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _householdIdController.dispose();
    _householdHeadController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _observationsController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Survey Data'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showAnalytics ? Icons.assignment : Icons.analytics),
            onPressed: () {
              setState(() {
                _showAnalytics = !_showAnalytics;
              });
            },
            tooltip: _showAnalytics ? 'Show Form' : 'Show Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveSurveyData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: _showAnalytics ? _buildAnalyticsView() : Form(
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
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.explore,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Field Survey Data Collection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Surveyor: ${widget.userType}',
                          style: TextStyle(
                            color: Colors.orange.shade100,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Survey Information Section
                _buildSectionCard(
                  title: 'Survey Information',
                  icon: Icons.assignment,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _surveyType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Survey Type',
                        labelStyle: TextStyle(fontSize: 11),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: _surveyTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type, 
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _surveyType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _areaType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Area Type',
                        labelStyle: TextStyle(fontSize: 11),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: _areaTypes.map((area) {
                        return DropdownMenuItem(
                          value: area,
                          child: Text(
                            area,
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _areaType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Survey Date: ${_surveyDate.day}/${_surveyDate.month}/${_surveyDate.year}',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _surveyDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _surveyDate = date;
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

                // Household Information Section
                _buildSectionCard(
                  title: 'Household Information',
                  icon: Icons.home,
                  children: [
                    TextFormField(
                      controller: _householdIdController,
                      decoration: const InputDecoration(
                        labelText: 'Household ID',
                        prefixIcon: Icon(Icons.tag, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Household ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _householdType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Household Type',
                        prefixIcon: Icon(Icons.family_restroom, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: _householdTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type, 
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _householdType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _householdHeadController,
                      decoration: const InputDecoration(
                        labelText: 'Head of Household',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Head of household name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Complete Address',
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),

                // Family Composition Section
                _buildSectionCard(
                  title: 'Family Composition',
                  icon: Icons.groups,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people, color: Colors.orange.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Total Members: $_totalMembers',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildCounterField(
                                  'Male',
                                  _maleMembers,
                                  (value) {
                                    setState(() {
                                      _maleMembers = value;
                                      _updateTotalMembers();
                                    });
                                  },
                                  Icons.man,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildCounterField(
                                  'Female',
                                  _femaleMembers,
                                  (value) {
                                    setState(() {
                                      _femaleMembers = value;
                                      _updateTotalMembers();
                                    });
                                  },
                                  Icons.woman,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Age Group Distribution',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            'Under 5',
                            _childrenUnder5,
                            (value) {
                              setState(() {
                                _childrenUnder5 = value;
                                _updateTotalMembers();
                              });
                            },
                            Icons.child_care,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCounterField(
                            '5-18 years',
                            _children5to18,
                            (value) {
                              setState(() {
                                _children5to18 = value;
                                _updateTotalMembers();
                              });
                            },
                            Icons.school,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterField(
                            '18-60 years',
                            _adults18to60,
                            (value) {
                              setState(() {
                                _adults18to60 = value;
                                _updateTotalMembers();
                              });
                            },
                            Icons.work,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCounterField(
                            'Above 60',
                            _elderlyAbove60,
                            (value) {
                              setState(() {
                                _elderlyAbove60 = value;
                                _updateTotalMembers();
                              });
                            },
                            Icons.elderly,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Socio-Economic Information
                _buildSectionCard(
                  title: 'Socio-Economic Information',
                  icon: Icons.attach_money,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _incomeRange,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Household Income',
                        prefixIcon: Icon(Icons.currency_rupee, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: _incomeRanges.map((range) {
                        return DropdownMenuItem(
                          value: range,
                          child: Text(
                            range,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _incomeRange = value!;
                        });
                      },
                    ),
                  ],
                ),

                // Infrastructure & Facilities Section
                _buildSectionCard(
                  title: 'Infrastructure & Facilities',
                  icon: Icons.build,
                  children: [
                    _buildCheckboxTile(
                      'Safe Drinking Water Access',
                      _safeWaterAccess,
                      (value) => setState(() => _safeWaterAccess = value ?? false),
                      Icons.water_drop,
                    ),
                    _buildCheckboxTile(
                      'Sanitation Facilities',
                      _sanitationFacilities,
                      (value) => setState(() => _sanitationFacilities = value ?? false),
                      Icons.bathroom,
                    ),
                    _buildCheckboxTile(
                      'Electricity Available',
                      _electricityAvailable,
                      (value) => setState(() => _electricityAvailable = value ?? false),
                      Icons.electrical_services,
                    ),
                    _buildCheckboxTile(
                      'Solid Waste Management',
                      _solidWasteManagement,
                      (value) => setState(() => _solidWasteManagement = value ?? false),
                      Icons.delete,
                    ),
                  ],
                ),

                // Health Status Section
                _buildSectionCard(
                  title: 'Health Status',
                  icon: Icons.health_and_safety,
                  children: [
                    _buildCheckboxTile(
                      'Vaccination Up-to-Date',
                      _vaccinationUpToDate,
                      (value) => setState(() => _vaccinationUpToDate = value ?? false),
                      Icons.vaccines,
                    ),
                    _buildCheckboxTile(
                      'Chronic Disease Present',
                      _chronicDiseasePresent,
                      (value) => setState(() => _chronicDiseasePresent = value ?? false),
                      Icons.sick,
                    ),
                    _buildCheckboxTile(
                      'Pregnant Women Present',
                      _pregnantWomenPresent,
                      (value) => setState(() => _pregnantWomenPresent = value ?? false),
                      Icons.pregnant_woman,
                    ),
                    _buildCheckboxTile(
                      'Elderly Need Special Care',
                      _elderlyNeedCare,
                      (value) => setState(() => _elderlyNeedCare = value ?? false),
                      Icons.elderly_woman,
                    ),
                    _buildCheckboxTile(
                      'Children Show Malnutrition Signs',
                      _childrenMalnourished,
                      (value) => setState(() => _childrenMalnourished = value ?? false),
                      Icons.child_care,
                    ),
                  ],
                ),

                // Observations and Recommendations Section
                _buildSectionCard(
                  title: 'Observations & Recommendations',
                  icon: Icons.notes,
                  children: [
                    TextFormField(
                      controller: _observationsController,
                      decoration: const InputDecoration(
                        labelText: 'Key Observations',
                        prefixIcon: Icon(Icons.visibility),
                        hintText: 'Important observations during the survey...',
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
                      controller: _recommendationsController,
                      decoration: const InputDecoration(
                        labelText: 'Recommendations',
                        prefixIcon: Icon(Icons.recommend),
                        hintText: 'Recommendations for health improvement...',
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
                    onPressed: _isLoading ? null : _saveSurveyData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Survey Data',
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
                Icon(icon, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.orange.shade700, size: 14),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                  textAlign: TextAlign.center,
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
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              InkWell(
                onTap: () => onChanged(value + 1),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.orange.shade700,
                    size: 18,
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
          Icon(icon, color: Colors.orange.shade700, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title, 
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orange.shade700,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  void _updateTotalMembers() {
    _totalMembers = _childrenUnder5 + _children5to18 + _adults18to60 + _elderlyAbove60;
  }

  Future<void> _saveSurveyData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final surveyData = {
        'householdId': _householdIdController.text,
        'householdHead': _householdHeadController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'surveyType': _surveyType,
        'areaType': _areaType,
        'householdType': _householdType,
        'surveyDate': _surveyDate.toIso8601String(),
        'familyComposition': {
          'totalMembers': _totalMembers,
          'maleMembers': _maleMembers,
          'femaleMembers': _femaleMembers,
          'childrenUnder5': _childrenUnder5,
          'children5to18': _children5to18,
          'adults18to60': _adults18to60,
          'elderlyAbove60': _elderlyAbove60,
        },
        'socioEconomic': {
          'incomeRange': _incomeRange,
        },
        'infrastructure': {
          'safeWaterAccess': _safeWaterAccess,
          'sanitationFacilities': _sanitationFacilities,
          'electricityAvailable': _electricityAvailable,
          'solidWasteManagement': _solidWasteManagement,
        },
        'healthStatus': {
          'vaccinationUpToDate': _vaccinationUpToDate,
          'chronicDiseasePresent': _chronicDiseasePresent,
          'pregnantWomenPresent': _pregnantWomenPresent,
          'elderlyNeedCare': _elderlyNeedCare,
          'childrenMalnourished': _childrenMalnourished,
        },
        'observations': _observationsController.text,
        'recommendations': _recommendationsController.text,
        'surveyor': widget.userType,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save to health data service
      await HealthDataService.saveSurveyData(surveyData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Field survey data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving survey data: $e'),
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
    _householdIdController.clear();
    _householdHeadController.clear();
    _addressController.clear();
    _phoneController.clear();
    _observationsController.clear();
    _recommendationsController.clear();
    
    setState(() {
      _surveyType = 'Door-to-Door Health Survey';
      _areaType = 'Urban';
      _householdType = 'Nuclear Family';
      _surveyDate = DateTime.now();
      _safeWaterAccess = false;
      _sanitationFacilities = false;
      _electricityAvailable = false;
      _solidWasteManagement = false;
      _vaccinationUpToDate = false;
      _chronicDiseasePresent = false;
      _pregnantWomenPresent = false;
      _elderlyNeedCare = false;
      _childrenMalnourished = false;
      _totalMembers = 1;
      _maleMembers = 0;
      _femaleMembers = 0;
      _childrenUnder5 = 0;
      _children5to18 = 0;
      _adults18to60 = 0;
      _elderlyAbove60 = 0;
      _incomeRange = 'Below 10,000';
    });
  }
}
